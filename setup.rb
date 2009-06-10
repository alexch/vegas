require 'rubygems'
require 'activesupport'
require 'activerecord'

# 'req' is a simple replacement for 'require' for use in a project
# whose file layout uses subdirectories that does away with some
# annoyances like using '..' or 'RAILS_ROOT' all over the place. 
#
# Put this file in your project root directory and add your source
# root directories to the ROOT_DIRS array. In your main app, require 
# this file. Then inside your sources, do all your requires with req
# relative to this root directory and they'll get found.
#
# It also tries to pre-require all files it finds in those source dirs,
# in alphabetical order, but it'll miss some, so you may need to declare
# more req's in files that need them.
#
ROOT = File.expand_path(File.dirname(__FILE__))
$:.unshift ROOT
Dir.chdir(ROOT)

ROOT_DIRS = ["lib", "domain", "views"]

def req(file)
  unless file =~ /^\//
    file = "#{ROOT}/#{file}"
  end
  # puts "requiring #{file}"
  require file  # using "load" allows auto-reloading, in theory
rescue => e
  $stderr.puts "Error while requiring '#{file}'"
  raise e
end

# Put frozen gems on the load path
Dir["#{ROOT}/vendor/gems/*"].sort.each do |path|
  $: << "#{path}/lib"
end

# Load frozen gems
Dir["#{ROOT}/vendor/gems/*"].sort.each do |path|
  gem_name = path.gsub(/.*\//, '').gsub(/-[0-9.]+$/, '')
  begin
    require gem_name
  rescue => e
    puts "Problem while loading gem #{gem_name}:"
    p e
  end
end

# Load plugins (assumes no dependencies between plugins)
Dir["#{ROOT}/vendor/plugins/*"].sort.each do |path|
  $: << "#{path}/lib"
  init_file = "#{path}/init.rb"
  req init_file if File.exist?(init_file)
end

# Put application directories on the load path
ROOT_DIRS.each do |dir|
  Dir["#{ROOT}/#{dir}/**/*.rb"].sort.each do |file|
    req file
  end
end

## Utility functions

def profile
  x = ""
  require 'ruby-prof'

  # Profile the code
  result = RubyProf.profile do
    x = yield
  end

  # Print a graph profile to text
  printer = RubyProf::FlatPrinter.new(result)
  printer.print(STDOUT, 0)

  x
end

## Monkey Patches

module ActiveRecord
  module ConnectionAdapters
    class AbstractAdapter
      def log_info(sql, name, ms)
        if @logger && @logger.debug?
          c = caller.detect{|line| line !~ /(activerecord|active_support|__DELEGATION__|vendor)/i}
          c.gsub!("#{File.expand_path(File.dirname(RAILS_ROOT))}/", '') if defined?(RAILS_ROOT)
          name = '%s (%.1fms) %s' % [name || 'SQL', ms, c]
          @logger.debug(format_log_entry(name, sql.squeeze(' ')))
        end
      end
    end
  end
end

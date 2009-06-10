require 'rubygems'
require 'activesupport'
require 'activerecord'

# Vegas adds the project root directory to the load path ($:).
# So if you want to require another file, even if it's in the same
# directory as the current file, you must specify its full path
# relative to the project root. The tradeoff is that with this
# convention, you're less likely to get 'double includes' since
# every reference to a file will have the same name.
#
# Vegas also automatically pre-requires all files underneath any
# subdirectory in the ROOT_DIRS array. But it'll miss some, and
# since it doesn't do Rails-style automatic class loading, you may need to
# explicitly require some dependencies... if their names are
# alphabetically greater than the name of the current file.
# (Yeah, that's a code smell, but the other choice is to override
# Object.const_missing like Rails does... which might not be such a bad
# idea...)
#
# Simple instructions: Put this file (setup.rb) in your project
# root directory and add your source
# directories to the ROOT_DIRS array. In your main app, require
# setup.rb. Then inside your sources, do all your requires
# relative to the project root directory and they'll get found.
#
ROOT = File.expand_path(File.dirname(__FILE__))
$:.unshift ROOT
Dir.chdir(ROOT)

ROOT_DIRS = ["lib", "domain", "views"]

# Put frozen gems on the load path
Dir["vendor/gems/*"].sort.each do |path|
  $: << "#{path}/lib"
end

# Load frozen gems
Dir["vendor/gems/*"].sort.each do |path|
  gem_name = path.gsub(/.*\//, '').gsub(/-[0-9.]+$/, '')
  begin
    require gem_name
  rescue => e
    puts "Problem while loading gem #{gem_name}:"
    p e
  end
end

# Load plugins (assumes no dependencies between plugins)
Dir["vendor/plugins/*"].sort.each do |path|
  $: << "#{path}/lib"
  init_file = "#{path}/init.rb"
  require init_file if File.exist?(init_file)
end

# pre-require files underneath source root directories
ROOT_DIRS.each do |dir|
  Dir["#{dir}/**/*.rb"].sort.each do |file|
    require file
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

require 'rubygems'
require 'activerecord'
require 'erector/lib/erector'

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
$: << ROOT
Dir.chdir(ROOT)

ROOT_DIRS = ["lib", "domain", "views"]

def req(file)
  unless file =~ /^\//
    file = "#{ROOT}/#{file}"
  end
  # puts "requiring #{file}"  # uncomment for debugging
  require file  # using "load" allows auto-reloading, in theory, but I can't get it to work
end

ROOT_DIRS.each do |dir|
  Dir["#{ROOT}/#{dir}/*.rb"].sort.each do |file|
    req file
  end
end

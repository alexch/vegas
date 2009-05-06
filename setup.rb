require 'rubygems'
require 'activerecord'

ROOT = File.expand_path(File.dirname(__FILE__))
$: << ROOT
Dir.chdir(ROOT)

def req(file)
  unless file =~ /^\//
    file = "#{ROOT}/#{file}"
  end
  # puts "requiring #{file}"
  require file  # using "load" allows auto-reloading, in theory
end

require 'erector/lib/erector'

["lib", "domain", "views"].each do |dir|
  Dir["#{ROOT}/#{dir}/*.rb"].sort.each do |file|
    req file
  end
end

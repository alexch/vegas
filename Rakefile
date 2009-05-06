require 'rake'
require 'rake/testtask'
require 'lib/db'

task :default => :test

Dir["lib/tasks/**/*.rake"].sort.each { |ext| load ext }

task :environment do
  require 'activerecord'
  unless defined?(RAILS_ENV)
    RAILS_ENV = ENV['RAILS_ENV'] || ENV['ENV'] || 'development'
  end
  ENV['RACK_ENV'] = RAILS_ENV
  connect_to(RAILS_ENV)
  RAILS_ROOT = File.dirname(__FILE__)
end

task :test do
  ENV['ENV'] = "test"
  Rake::Task["test:all"].invoke
end
  
namespace :test do  
  Rake::TestTask.new(:all => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/**/*_test.rb'
    t.verbose = true
  end
end

task :run do
  system "ruby run.rb"
  # system "shotgun --server=thin --port=4000 config.ru"
end

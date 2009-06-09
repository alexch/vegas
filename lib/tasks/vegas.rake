task :environment do
  require 'activerecord'
  unless defined?(RAILS_ENV)
    RAILS_ENV = ENV['RAILS_ENV'] || ENV['ENV'] || 'development'
  end
  ENV['RACK_ENV'] = RAILS_ENV
  DB.connect_to(RAILS_ENV)
  RAILS_ROOT = File.dirname(__FILE__)
end

desc "Run all Test::Unit tests"
task :test do
  ENV['ENV'] = "test"
  Rake::Task["test:all"].invoke
end

namespace :test do
  Rake::TestTask.new(:all) do |t|
    t.libs << "test"
    t.pattern = 'test/**/*_test.rb'
    t.verbose = false
  end
end

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  ENV['ENV'] = "test"
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "Run the app, restarting when a file changes"
task :run do
  system "ruby run.rb"
  # system "shotgun --server=thin --port=4000 config.ru"
end

task :annotate do
  system "annotate --model-dir domain -i -R setup.rb"
end

task :console do
  system "irb -r console.rb"
end

namespace :db do
  task :migrate do
    Rake::Task["annotate"].invoke
  end
end

# Rake tasks to make life with Heroku a bit easier
#
# by Alex Chaffee (alex@stinky.com)

def app_url
  `heroku info | grep "Web URL" | sed 's/Web URL://'`.strip
end

def app_name
  File.expand_path(File.dirname(__FILE__)).split('/').last
end

def pull_db(env)
  system "heroku db:pull mysql://root:password@localhost/#{app_name}_#{env}"
end

def status_clean?
  out = `git status`
  !out.split("\n").grep(/nothing to commit/).empty?
end

def on_master?
  out = `git branch --no-color`
  out =~ /^\* master$/
end

###

namespace :db do
  desc "pull db from heroku"
  task :pull => :environment do
    system "heroku db:pull mysql://root:password@localhost/#{app_name}_#{RAILS_ENV}"
  end
  desc "push db to heroku"
  task :push => :environment do
    system "heroku db:push mysql://root:password@localhost/#{app_name}_#{RAILS_ENV}"
  end
end

desc "push app to heroku"
task :push => :environment do
  raise "Aborting push: there are local changes." unless status_clean?
  raise "Aborting push: you are not on 'master' branch." unless on_master?
  now = Time.now.strftime("%Y-%m-%d %H:%M")
  now_db = Time.now.strftime("%Y%m%d%H%M")
  File.open("public/deployed.txt", 'w') do |f|
    f.write(now);
    f.write(" [#{ActiveRecord::Migrator.current_version}]")
  end
  system "git add public/deployed.txt"
  system "git ci -m 'pushing to heroku #{now}'"
  system "mysql -uroot -ppassword -e 'create database #{app_name}_#{now_db}'"
  pull_db(now_db)
  system "git push heroku"
  sleep 2
  result = `curl #{app_url}`
  if result.grep(now)
    puts "Push successful."
  else
    puts "Hmm, push seems to have failed."
  end
end


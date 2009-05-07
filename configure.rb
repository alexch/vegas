enable :methodoverride
enable :sessions
# use Rack::Session::Pool  # doesn't work :-(

configure :production do
  # redirect standard out and standard error to the production log file
  log = File.new("log/production.log", "a")
  STDOUT.reopen(log)
  STDERR.reopen(log)
end

configure do
  opt = Sinatra::Application
  puts "Starting application on #{opt.host}:#{opt.port}"
  stuff = [:environment, :raise_errors, :logging, :root, :app_file].collect do |option_name|
    value = eval("opt.#{option_name}")
    "#{option_name}=#{value}"
  end
  puts stuff.join(", ")
end

configure do
  connect_to(Sinatra::Application.environment)
end

configure do
  # Always migrate
  ActiveRecord::Migration.verbose = true
  ActiveRecord::Migrator.migrate("db/migrate", nil)
end

configure :test, :development do
  Erector::Widget.prettyprint_default = true
end


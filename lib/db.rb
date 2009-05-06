def connect_to(db_environment)
  puts "Connecting to #{db_environment} database"
  ActiveRecord::Base.logger = Logger.new("log/#{db_environment}.log")
  dbconfig = YAML.load(File.read('config/database.yml'))
  ActiveRecord::Base.configurations = dbconfig
  ActiveRecord::Base.establish_connection dbconfig[db_environment.to_s]
end

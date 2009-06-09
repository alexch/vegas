module DB
  def self.connect_to(db_environment)
    puts "Connecting to #{db_environment} database"
    ActiveRecord::Base.logger = Logger.new("log/#{db_environment}.log")
    dbconfig = YAML.load(File.read('config/database.yml'))
    ActiveRecord::Base.configurations = dbconfig
    ActiveRecord::Base.establish_connection dbconfig[db_environment.to_s]
  end
  
  def self.setup
    ActiveRecord::Base.connection.increment_open_transactions
    ActiveRecord::Base.connection.begin_db_transaction
  end
  
  def self.teardown
    if ActiveRecord::Base.connection.open_transactions != 0
      ActiveRecord::Base.connection.rollback_db_transaction
      ActiveRecord::Base.connection.decrement_open_transactions
    end
    ActiveRecord::Base.clear_active_connections!
  end
  
end

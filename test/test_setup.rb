require File.expand_path("#{File.dirname(__FILE__)}/../setup")

require 'test/unit'
require 'sinatra'
require 'sinatra/test'

set :environment, :test
connect_to("test")
ActiveRecord::Migration.verbose = true
ActiveRecord::Migrator.migrate("db/migrate", nil)

class MyTestCase < Test::Unit::TestCase
  
  def default_test
    super unless self.class == MyTestCase
  end
  
  def setup
    super
    ActiveRecord::Base.connection.increment_open_transactions
    ActiveRecord::Base.connection.begin_db_transaction
  end
  
  def teardown
    if ActiveRecord::Base.connection.open_transactions != 0
      ActiveRecord::Base.connection.rollback_db_transaction
      ActiveRecord::Base.connection.decrement_open_transactions
    end
    ActiveRecord::Base.clear_active_connections!
    super
  end
  
end

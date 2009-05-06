class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.string :name
      t.string :hashed_password
      t.string :salt
    end
  end
  
  def self.down
    drop_table :users
  end
end

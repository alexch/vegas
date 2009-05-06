class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :author_id, :integer
      t.column :article_id, :integer
      t.column :body, :string
    end
  end

  def self.down
    drop_table :comments
  end
end

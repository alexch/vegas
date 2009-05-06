class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :author_id, :integer
      t.column :name, :string
      t.column :body, :string
    end
  end

  def self.down
    drop_table :articles
  end
end

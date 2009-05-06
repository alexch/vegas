# == Schema Information
#
# Table name: articles
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  author_id  :integer(4)
#  name       :string(255)
#  body       :string(255)
#

class Article < ActiveRecord::Base

  belongs_to :author, :class_name => "User"
  has_many :comments

  def add_comment(user, text)
    Comment.create!(:article_id => self.id, :author_id => user, :body => text)
  end
  
  # layer separation is for suckers
  def url
    "/article/#{self.to_param}"
  end
  
  def at
    created_at
  end
    
end

# == Schema Information
#
# Table name: comments
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  author_id  :integer(4)
#  article_id :integer(4)
#  body       :string(255)
#

class Comment < ActiveRecord::Base

  belongs_to :author, :class_name => "User"
  belongs_to :article

  def at
    created_at
  end
end

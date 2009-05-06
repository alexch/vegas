# == Schema Information
#
# Table name: users
#
#  id              :integer(4)      not null, primary key
#  created_at      :datetime
#  updated_at      :datetime
#  name            :string(255)
#  hashed_password :string(255)
#  salt            :string(255)
#

require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :articles, :foreign_key => "author_id"

  # todo
  # validates_present :login, :email

  def password=(pass)
    @password = pass
    self.salt = random_string(10) unless self.salt
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  def random_string(len)
   chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
   str = ""
   1.upto(len) { |i| str << chars[rand(chars.size-1)] }
   return str
  end

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass + salt)
  end
  
  def self.authenticate(name, pass)
    u = User.find_by_name(name)
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt) == u.hashed_password
    nil
  end

end

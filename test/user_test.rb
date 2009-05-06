require File.expand_path("#{File.dirname(__FILE__)}/test_setup")

class UserTest < MyTestCase  
  def setup
    super
    User.delete_all
  end
  
  def test_create
    user = User.create(:name => "foo")
    user.reload
    assert_equal "foo", user.name
  end
  
  def test_set_password
    user = User.create(:name => "foo")
    user.password = "pass"
    assert_not_nil user.salt
    assert_equal User.encrypt("pass", user.salt), user.hashed_password
  end
  
  def test_authenticate
    saved = User.create(:name => "foo", :password => "pass")
    authenticated = User.authenticate("foo", "pass")
    assert_equal saved, authenticated
  end
  
  def test_authenticate_with_bad_name
    saved = User.create(:name => "foo", :password => "pass")
    authenticated = User.authenticate("bar", "pass")
    assert_nil authenticated
  end

  def test_authenticate_with_bad_password
    saved = User.create(:name => "foo", :password => "pass")
    authenticated = User.authenticate("foo", "nopass")
    assert_nil authenticated
  end

end
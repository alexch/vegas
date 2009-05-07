require File.expand_path("#{File.dirname(__FILE__)}/test_setup")

require "rack/test"
require 'app'
require 'hpricot'

use Rack::Session::Pool  # for some reason this works in test and fails in the wild

class AppTest < MyTestCase

  ### rack-test stuff
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  def response
    last_response
  end
  
  def response_body
    response.body.join  # the body is an array in Rack land
  end
  
  def request(*args)
    args.empty? ? last_request : rack_test_session.request(*args)
  end
  
  def session
    last_request.env['rack.session']
  end
  ###

  def setup
    super
    @good_password = "pass"
    @nicola = User.create(:name => "nicola", :password => @good_password)
    @alphonse = User.create(:name => "alphonse", :password => @good_password)
  end

  def login(user = @nicola, password = @good_password)
    post '/login', :name => user.name, :password => password
  end
  
  attr_reader :nicola

  ## home
  
  def test_it_loads_ok
    get '/'
    assert last_response.ok?
  end
  
  ## login
  
  def test_login_form
    get '/login'
    assert response.ok?
  end
  
  def test_login
    login(@nicola)
    assert response.redirect?
    assert_equal "Login successful.", session[:flash]
    assert_equal nicola, session[:user]
  end

  def test_login_box_is_visible_when_no_current_user    
    # todo
  end
  
  def test_login_box_is_not_visible_when_there_is_a_current_user
    # todo
  end
  
  def test_logout
    login(@nicola)
    assert_equal nicola, session[:user]
    follow_redirect!
    assert_equal nicola, session[:user]
    get '/logout'
    assert response.redirect?
    assert_equal "Logout successful.", session[:flash]
    assert_nil session[:user]    
  end
  
  ## signup
  
  def test_signup_form
    get '/user'
    assert response.ok?
  end
  
  def test_signup
    user = User.find_by_name("foo")
    assert_nil user
    post '/user', :name => "foo", :password => "pass", :password_verify => "pass"
    assert response.redirect?
    user = User.find_by_name("foo")
    assert_not_nil user
    assert_equal user, session[:user], "After signup, new user should be signed in"
  end
  
  # todo: count before and after
  def assert_no_user_created(name = "foo")
    assert response.redirect?
    user = User.find_by_name(name)
    assert_nil user
    assert_nil session[:user]
  end

  # todo: test various error messages

  def test_signup_missing_verify
    post '/user', :name => "foo", :password => "pass", :password_verify => "nopass"
    assert_no_user_created
  end

  def test_signup_with_blank_password
    post '/user', :name => "foo", :password => "", :password_verify => ""
    assert_no_user_created
  end
  
  def test_signup_with_blank_username
    post '/user', :name => "", :password => "pass", :password_verify => "nopass"
    assert_no_user_created
  end

  def test_signup_with_duplicate_username
    user = User.create(:name => "foo", :password => "pass")
    post '/user', :name => "foo", :password => "pass", :password_verify => "nopass"
    assert response.redirect?
    users_named_foo = User.find_all_by_name("foo")
    assert_equal 1, users_named_foo.size
    assert_equal user, users_named_foo.first
    assert_nil session[:user]
  end
  
  ## article
  
  def test_creating_article_when_nobody_logged_in
    post '/article', :name => "eat lunch"
    assert_equal 1, Article.count
    article = Article.all.first
    assert_equal "eat lunch", article.name
    assert_nil article.author
  end
  
  def test_creating_article_uses_current_user_as_author
    login(@nicola)
    post '/article', :name => "eat lunch"
    article = Article.all.first
    assert_equal "eat lunch", article.name
    assert_equal nicola, article.author
  end
  
  def test_inplace_edit_name
    login(@nicola)
    article = Article.create(:name => "foo")
    post "/article/#{article.id}/name", :value => "bar"
    assert response.ok?
    article.reload
    assert_equal "bar", article.name
    assert_equal "bar", response_body
  end
  
  def test_inplace_edit_author
    login(@nicola)
    article = Article.create(:name => "foo")
    assert_nil article.author
    post "/article/#{article.id}/author", :value => "#{nicola.to_param}"
    assert response.ok?
    article.reload
    assert_equal nicola, article.author
    assert_equal nicola.name, response_body
  end

  def test_autocomplete_article_search
    login(@nicola)
    foo = Article.create(:name => "foo")
    bar = Article.create(:name => "bar")
    baz = Article.create(:name => "baz")
    get "/search?q=BA"
    assert_equal "bar|#{bar.id}\nbaz|#{baz.id}", response_body
  end

  def test_autocomplete_article_search_with_limit
    login(@nicola)
    20.times do |i|
      Article.create(:name => "foo #{i}")
    end
    get "/search?q=foo&limit=10"
    results = response_body.split("\n")
    assert_equal 10, results.size
  end

  ## comment
  
  def test_creating_comment_uses_current_user_as_author
    login(@nicola)
    article = Article.create(:name => "eat lunch", :author_id => @alphonse)
    post "/article/#{article.id}/comment", :body => "i'd like a burrito"
    assert response.ok?
    comment = article.comments.first
    assert_equal "i'd like a burrito", comment.body
    assert_equal nicola, comment.author
    assert_equal article, comment.article
  end
  
end

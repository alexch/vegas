require File.expand_path("#{File.dirname(__FILE__)}/setup")
require 'sinatra'

set :root, File.dirname(__FILE__)
set :app_file, __FILE__

load 'configure.rb'
load 'helpers.rb'

## login

get '/login' do
  Login.new.to_s
end

post '/login' do
  if session[:user] = User.authenticate(params["name"], params["password"])
    flash("Login successful.")
  else
    flash("Login failed - Please try again.")
  end
  redirect '/'
end

get '/logout' do
  session[:user] = nil
  flash("Logout successful.")
  redirect '/'
end

## user

get '/user' do
  render_page SingleWidgetPage, :widget_class => CreateUser
end

post '/user' do
  if params["password"] != params["password_verify"]
    flash("Password and verification didn't match.")
  elsif params["password"].blank?
    flash("Please enter a password.")
  elsif params["name"].blank?
    flash("Please enter a name.")
  else
    existing_user = User.find_by_name(params["name"])
    unless existing_user.nil?
      flash("That name has already been taken. Please choose a different one.")
    else
      u = User.new
      u.name = params["name"]
      u.password = params["password"]    
      if u.save
        session[:user] = u
        flash("User created.")
        redirect '/'
        return
      else
        tmp = []
        u.errors.each do |e|
          tmp << (e.join("<br/>"))
        end
        flash(tmp)
      end
    end
  end
  redirect '/user'
end

## above this line: login not required

get '*' do
  pass if logged_in?
  flash("Please log in.") unless flash?
  render_page VegasPage
  # todo: encode post-login destination
end

## below this line: login required

## home
get '/' do
  render_page MainPage, :users => User.find(:all)
end

get "/user/:id" do
  user = User.find(params[:id])
  render_page UserPage, :user => user
end

get "/article/new" do
  view = ArticleForm.new(:author => current_user)
  render_page SingleWidgetPage, :widget_class => view
end

get "/article" do
  article = Article.find(params[:id])
  redirect article.url
end

get "/article/:id" do
  article = Article.find(params[:id])
  article_view = FullArticle.new(:article => article, :current_user => current_user)
  render_page SingleWidgetPage, :widget_class => article_view
end

post "/article" do
  article = Article.create(:name => request[:name], :author => current_user, :body => request[:body])
  #todo: error handling
  redirect article.url
end

post "/article/:id/name" do
  (article = Article.find(params[:id])).name = params["value"]
  article.save!
  article.name # XHR
end

post "/article/:id/author" do
  (article = Article.find(params[:id])).author = User.find(params["value"])
  article.save!
  article.author.name # XHR
end

post "/article/:id/comment" do
  article = Article.find(params[:id])
  comment = article.comments.create(:author => current_user, :body => params[:body])
  CommentView.new(:comment => comment).to_s  # XHR
end

# for jQuery autocomplete
get "/search" do  
  query = params[:q]
  articles = Article.find(:all, :conditions => ['LOWER(name) LIKE ?', "%#{query.downcase}%"], :limit => params[:limit])
  articles.map{|article| "#{article.name}|#{article.id}"}.join("\n")
end


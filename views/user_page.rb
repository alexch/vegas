req 'views/vegas_page'

class UserPage < VegasPage

  needs :current_user, :user
  
  def main_content
    h1 user.name
    p "Member since #{user.created_at}"
    h2 "Articles:"
    widget ArticleList.new(:articles => user.articles)
  end

end

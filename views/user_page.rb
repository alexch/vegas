req 'views/vegas_page'

class UserPage < VegasPage

  needs :current_user, :user
  
  def main_content
    widget ArticleList, :users => users
  end

end

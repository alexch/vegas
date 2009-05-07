req 'views/vegas_page'

class MainPage < VegasPage

  needs :users
  
  def main_content
    widget UserList.new(:users => users)
  end


end

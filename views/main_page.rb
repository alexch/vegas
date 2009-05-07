req 'views/vegas_page'

class MainPage < VegasPage

  needs :users
  
  style <<-STYLE
    .links {
      max-width: 20em;
      border: 1px solid black;
      padding: 1em;
      vertical-align: top;
    }
    
    .links ul {
      list-style: none;
      padding: 0px 0px 1em 1em;
    }
    
    .links li {
      padding: 0px;
    }
    
  STYLE
  
  def main_content
    table :class => "layout", :id => "main_table" do
      tr do
        td do
          widget UserList.new(:users => users)
        end
        td :class => "links" do
          links
        end
      end
    end
  end

  def links
    li do
      text "Links Here!!!"
    end
  end

end

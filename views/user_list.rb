require 'views/page'

class UserList < Erector::Widget

  needs :users
  
  Page.js "/lib/jquery.js"
  
  Page.style <<-STYLE
    ul.user_list {
      list-style: none;
      vertical-align: top;
      border: 1px solid black;
      min-width: 12em;
    }

    ul.article_list {
      min-width: 30em;
      width: 100%;
    }

    ul.article_list li {
    	padding: .5em;
    }
    
    li.userlist_item.on {
      background-color: #77F;
    }
    
    ul.user_list li:hover {
      background-color: lightblue;
    }
    
  STYLE

  Page.jquery "$('ul.article_list li:odd').css({backgroundColor: '#ddd'});"

  def content
    ul :class => "user_list" do
      @users.each do |user|
        li do
          text "All articles by "
          a user.name, :href => "/user/#{user.to_param}"
          widget ArticleList, :articles => user.articles
        end
      end
    end
  end
end

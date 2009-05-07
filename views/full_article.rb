req 'views/page'

class FullArticle < Erector::Widget

  needs :current_user, :article
  
  Page.js "/lib/jquery.js"
  
  Page.style <<-STYLE
    div.article_body {
      border: 1px solid gray;
      padding: 2em;
    }
  STYLE

  def content
    h3 article.name
    widget Byline, :user => article.author, :at => article.at

    p
    
    div :class => "article_body" do
      text article.body
    end

    if current_user == article.author
      # todo: make this activate inline editing widgets
      input :type => "button", :value => "Edit"
    end

    hr
    
    ul :class => "comments" do
      article.comments.each do |comment|
        li :class => "comment" do
          div :class => "comment_body" do
            widget CommentView.new(:comment => comment)
          end

          if current_user == comment.author
            # todo: make this activate inline editing widgets
            input :type => "button", :value => "Edit"
          end
        end
      end
    end
    
    widget CommentForm, :article => article
  end
end

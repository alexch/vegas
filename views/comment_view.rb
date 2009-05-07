require 'action_view' # todo: grab time_ago_in_words only

class CommentView < Erector::Widget
  include ActionView::Helpers::DateHelper
  
  needs :comment

  def content
    div :class => "comment" do
      text comment.body
      widget Byline, :user => comment.author, :at => comment.at
    end
  end
end

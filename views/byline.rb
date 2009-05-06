require 'action_view' # todo: extract time_ago_in_words only

class Byline < Erector::Widget
  needs :user, :at

  # shouldn't this be in ActiveSupport, not ActionView?
  include ActionView::Helpers::DateHelper

  def content
    span :class => "byline" do
      text "by "
      text user.name
      text " "
      span :title => at.to_s do # todo: nicer datetime formatting
        text time_ago_in_words(at)
        text " ago."
      end
    end
  end
end

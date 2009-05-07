req 'views/form'

class CommentForm < Erector::Widget
  needs :article

  def content
    widget Form, :action => "/article/#{article.to_param}/comment" do
      table = LabelTable.new(:title => "New Comment") do |table|
        table.field("body") do
          textarea :name => "body"
        end
        table.button do
          input :type => "submit", :name => "submit", :value => "Save"
        end
      end
      widget table
    end
  end
  
end

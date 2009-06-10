require 'views/form'

class ArticleForm < Erector::Widget

  def content
    widget Form, :action => "/article" do
      table = LabelTable.new(:title => "New Article") do |table|
        table.field("name") do
          input :type => "text", :name => "name"
        end
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

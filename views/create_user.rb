class CreateUser < Erector::Widget
  needs nil
  def content
    form :action => "/user", :method => "post" do
      widget(LabelTable.new(:title => "Sign Up") do |f|
        f.field("Name") do
          input(:name => "name", :type => "text", :size => "30")
        end
        f.field("Password") do
          input(:name => "password", :type => "password", :size => "30")
        end
        f.field("Password Again", 
          "Yes, we really want you to type your new password twice. Sorry about that.") do
          input(:name => "password_verify", :type => "password", :size => "30")
        end
        f.button do
          input(:name => "signup", :type => "submit", :value => "Sign Up")
        end
      end)
    end
  end
end

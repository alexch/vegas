class Login < Erector::Widget
  needs nil
  
  def content
    form :action => "/login", :method => "post" do
      widget(LabelTable.new(:title => "Login") do |f|
        f.field("Name") do
          input(:name => "name", :type => "text", :size => "30")
        end
        f.field("Password") do
          input(:name => "password", :type => "password", :size => "30")
        end
        f.button do
          input(:name => "signup", :type => "button", :value => "Sign Up", 
            :onclick => "document.location='/user';return false")
        end
        f.button do
          input(:name => "submit", :type => "submit", :value => "Log In")
        end
      end)
    end
  end
end

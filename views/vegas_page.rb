req 'views/page'

class VegasPage < Page
  
  needs :current_user, :flash => nil

  

  def page_title
    "vegas"
  end

  # todo: test all flash stuff, rename this method
  def render_flash
    if @flash
      p :class => "flash" do
        text @flash
      end
    end
  end
  
  def render_login
    div :class => "login_box" do
      if @current_user
        text "Hello, "
        text current_user.name
        text "!"
        text nbsp
        a "Logout", :href => "/logout"
      else
        widget Login
      end
    end
  end
  
  def render_logo
    div :class => "logo" do
      a :href => "/" do
        img :src => "/img/vegas_logo.jpg", :width => "258", :height => "206"
      end
      div :style => "position: relative; top: -40px; left: 80px;", :class => :logo do
        taglines = [
          "Rails is so last year",
          "Rails sucks",
          "Running Rails off the tracks",
          "Rails has outlived its uselessness",
          "Rails 3... today."
        ]
        span "Vegas: #{taglines[rand(taglines.size)]}", :class => "tagline"
      end
    end
  end
  
  def render_footer
    hr
    center do
      span :style => "font-size: 8pt;" do
        text "Vegas is now."
        text nbsp
        text "Copyright © #{Time.now.strftime('%Y')}"
      end
    end
  end
  
  def body_content
    render_login
    render_logo
    div :class => "clear"
    render_flash
    div :class => "search_box" do
      widget SearchBox
    end
    div :class => "main" do
      main_content
    end
    render_footer
  end
  
  # override me
  def main_content
    instance_eval(&@block) if @block  
  end

  style <<-STYLE

    body {
      font: 10pt "Lucida Sans";
    }

    h3 {
      margin: 0;
    }
    
    table.layout, table.layout tr, table.layout td {
      margin: 0px;
    }
    
    .action {
      color: #00f;
      background-color: transparent;
      border: none;
      cursor: pointer;
      cursor: hand;
      margin: 0px;
      padding: 0px;
    }
    
    div.logo {
      float: left;
    }

    div.login_box {
      float: right;
      width: 24em;
      text-align: right;
    }

    div.login_box, .login_box th {
      font-size: 10pt;
    }
    
    .flash {
      border: 2px solid orange;
      padding: .25em;
    }
    
    .tagline {
      color: red; 
      font: italic 12pt verdana,arial,helvetica;
      font-weight: bold;
    }
    
    div.main {
      min-width: 20em;
      max-width: 50em;
      margin: auto;
    }
    
    div.search_box {
      float: right;
    }
  STYLE
  
end

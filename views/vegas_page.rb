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
        img :src => "/img/vegas_logo.gif", :width => 380/2, :height => 303/2
      end
      div :style => "position: relative; top: -20px; left: 80px;", :class => :logo do
        taglines = [
          "Rails is so last year",
          "Running Rails off the tracks",
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
    div :class => "top" do
      render_logo
      render_login
      br
      br
      div :class => "search_box" do
        widget SearchBox
      end
      div :class => "clear"
    end
    hr
    render_flash
    table :cellpadding => "10" do
      tr do
        td :valign => "top" do
          div :class => "links" do
            links
          end
        end
        td do
          div :class => "main" do
            main_content
          end
        end
      end
    end
    render_footer
  end
  
  # override me
  def main_content
    instance_eval(&@block) if @block  
  end
  
  def links
    ul do
      li do
        a "Post New Article", :href => "/article/new"
      end
    end
  end
  
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

    div.top {
      min-height: 150px;
    }

    div.logo {
      position: absolute;
      top: 0px;
      left: 0px;
      float:left;
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
      max-width: 40em;
      margin: auto;
    }
    
    div.search_box {
      float: right;
      border: 1px solid black;
    }

    div.links {
      float: left;
      border: 1px solid black;
    }
  STYLE
  
end

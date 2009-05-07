# Erector Page base class.
#
# Allows for accumulation of script and style tags (see example below) with either
# external or inline content. External references are 'uniq'd, so it's a good idea to declare
# a js script in all widgets that use it, so you don't accidentally lose the script if you remove 
# the one widget that happened to declare it.
#
# At minimum, child classes must override #body_content. You can also get a "quick and dirty"
# page by passing a block to Page.new but that doesn't really buy you much.
#
# The script and style declarations are accumulated at class load time,
# This technique allows all widgets to add their own requirements to the page header
# without extra logic for declaring which pages include which nested widgets.
# Unfortunately, this means that every page in the application will share the same headers,
# which may lead to conflicts. If you want something to show up in the headers
# for just one page, override #head_content, call super, and emit it yourself.
#
# Author::   Alex Chaffee, alex@stinky.com 
#
# = Example Usage: 
#
#   class MyPage < Page
#     js "lib/jquery.js"
#     script "$(document).ready(function(){...});"
#     css "stuff.css"
#     style "li.foo { color: red; }"
#     
#     def page_title
#       "my app"
#     end
#     
#     def body_content
#       h1 "My App"
#       p "welcome to my app"
#     end
#   end
# 
#   class WidgetWithCss < Erector::Widget
#     Page.style "div.custom { border: 2px solid green; }"
#     
#     def content
#       div :class => "custom" do
#         text "green is good"
#       end
#     end
#   end
#
# = Thoughts:
#  * It may be desirable to unify #js and #script, and #css and #style, and have the routine be
#    smart enough to analyze its parameter to decide whether to add it to the list of external 
#    or inline references.
#
class Page < Erector::Widget
  
  @@js = []  
  def self.js(*files)
    files.each {|f| @@js << f unless @@js.include?(f) }
  end

  @@css = []
  def self.css(*files)
    files.each {|f| @@css << f unless @@css.include?(f) }
  end

  @@styles = []
  def self.style(txt)
    @@styles << txt
  end

  @@scripts = []
  def self.script(txt)
    @@scripts << txt
  end

  @@jqueries = []
  def self.jquery(txt)
    @@jqueries << txt
  end

  def doctype
    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
  end

  # override me
  def page_title
    "page"
  end

  def content
    rawtext doctype
    html :xmlns => 'http://www.w3.org/1999/xhtml', 'xml:lang' => 'en', :lang => 'en' do
      head do
        head_content
      end
      body do
        body_content
      end
    end
  end

  # override me (or instantiate Page with a block)
  def body_content
    instance_eval(&@block) if @block
  end

  def head_content
    meta 'http-equiv' => 'content-type', :content => 'text/html;charset=UTF-8'
    title page_title
    @@js.each do |file|
      script :type=>"text/javascript", :src => file
    end
    @@css.each do |file|
      link :rel=>"stylesheet", :href => file, :type => "text/css", :media => "all"
    end
    inline_styles
    inline_scripts
  end

  def inline_styles
    style :type=>"text/css", 'xml:space' => 'preserve' do
      rawtext "\n"
      @@styles.each do |txt|
        rawtext "\n"
        rawtext txt
      end
    end
  end
  
  def inline_scripts
    javascript do
      @@scripts.each do |txt|
        rawtext "\n"
        rawtext txt
      end
      @@jqueries.each do |txt|
        rawtext "\n"
        rawtext "$(document).ready(function(){\n"
        rawtext txt
        rawtext "\n});"
      end
    end
  end

  style <<-STYLE
    img {border: none}
    .right {float: right;}
    .clear {clear: both;}
  STYLE
  
end

class Erector::Widget
  def jquery(txt)
    javascript do
      rawtext "\n"
      rawtext "$(document).ready(function(){\n"
      rawtext txt
      rawtext "\n});"
    end
  end
end

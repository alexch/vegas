req 'views/page'

class SearchBox < Erector::Widget

  Page.css "/lib/jquery.autocomplete.css"
  Page.js "/lib/jquery.js"
  Page.js "/lib/jquery.autocomplete.js"

  def base_id
    "#{self.class.name}_#{self.object_id}"
  end

  def html_id(child_id)
    "#{base_id}_#{child_id}"
  end

  class SearchButton < Erector::Widget
    needs :selection_html_id

    def base_id
      "#{self.class.name.gsub(/:/, '_')}_#{self.object_id}"
    end

    def html_id(child_id)
      "#{base_id}_#{child_id}"
    end
    
    def content
      form :method => "get", :action => "/article" do
        input :type => "hidden",
                :id => html_id("current"),
                :name => "id",
                :value => 0
        input :type => "button", :value => "Go",
          :onclick => "#{grab_value}; this.form.submit();"
      end
    end
    
    def grab_value
      "$('##{html_id("current")}').val($('##{selection_html_id}').val())"
    end
  end
  
  def content
    div :class => "search" do

      # put the text field outside the form so it doesn't submit when you hit enter
      input :type => "text",
              :id => html_id("input"),
              :value => "",
              :size => 40
      input :type => "hidden",
              :id => html_id("selection"),
              :name => "target_article_id",
              :value => ""
      widget SearchButton.new(:selection_html_id => html_id("selection"))
      
      div :id => html_id("status")

      jquery <<-SCRIPT
          $("##{html_id("input")}").autocomplete(
              "/search",
              {
                  delay:10,
                  minChars:1,
                  matchSubset:1,
                  matchCase:0,
                  matchContains:1,
                  mustMatch:1,
                  selectFirst:0,
                  cacheLength:10,
                  onItemSelect:function(x) {alert("itemSelect " + x);},
                  onFindValue:function(x) {alert("findValue " + x);},
                  formatItem:function(data) { return data[0] },
                  autoFill:false
              }
          ).result(function(event, item, formatted) {
            var selected_id = item[1];
            $("##{html_id("status")}").text("Selected " + item[0]);
            $("##{html_id("selection")}").val(selected_id);
          });
      SCRIPT

    end

  end
  
end

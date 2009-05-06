require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

module BaseSpec
  class TestWidgetController < ActionController::Base
    def index_with_implicit_assigns
      @foobar = "foobar"
      render_widget TestWidget
    end

    def index_with_explicit_assigns
      render_widget TestWidget, :foobar => "foobar"
    end

    def index_with_render_colon_widget
      @foobar = "foobar"
      render :widget => TestWidget
    end
    
    def index_with_rjs_rendering_template
      render :update do |page|
        page.insert_html :top, 'foobar', TestFormWidget.new.to_s(:helpers => self)
      end
    end
  end

  class TestWidget < Erector::RailsWidget
    def content
      text @foobar
    end
  end
  
  class TestFormWidget < Erector::RailsWidget
    def content
      form_tag('/') do
        h1 "Create a foo"
        rawtext text_field_tag(:name)
      end
    end
  end

  describe TestWidgetController do
    context "rendering widgets" do
      before do
        @controller = BaseSpec::TestWidgetController.new
        @request = ActionController::TestRequest.new
        @response = ActionController::TestResponse.new
        class << @controller
          public :render
        end
      end

      describe "#render_widget" do
        it "instantiates a widget with implicit assigns" do
          @request.action = "index_with_implicit_assigns"
          @controller.process(@request, @response)
          @response.body.should == "foobar"
        end

        it "instantiates a widget with explicit assigns" do
          @request.action = "index_with_explicit_assigns"
          @controller.process(@request, @response)
          @response.body.should == "foobar"
        end
      end

      describe "#render :widget" do
        it "instantiates a widget with implicit assigns" do
          @request.action = "index_with_implicit_assigns"
          @controller.process(@request, @response)
          @response.body.should == "foobar"
        end

        describe "#render :widget" do
          it "instantiates a widget with explicit assigns" do
            @request.action = "index_with_render_colon_widget"
            @controller.process(@request, @response)
            @response.body.should == "foobar"
          end
        end
      end
      
      describe "#render :update" do
        it "overrides RJS output_buffer changes" do
          @request.action = "index_with_rjs_rendering_template"
          @controller.process(@request, @response)
          @response.body.should include("Element.insert")
        end
      end
    end
  end
end
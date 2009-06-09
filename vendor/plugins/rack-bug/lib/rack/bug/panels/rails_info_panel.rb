module Rack
  module Bug
    
    class RailsInfoPanel < Panel
      
      def name
        "rails_info"
      end
      
      def heading
        return unless defined?(Rails)
        "Rails #{Rails.version}"
      end

      def content
        return unless defined?(Rails)
        render_template "panels/rails_info"
      end
      
    end
    
  end
end

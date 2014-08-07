require 'caracal/core/models/line_break_model'
require 'caracal/core/models/page_break_model'


module Caracal
  module Core
    
    # This module encapsulates all the functionality related to adding line
    # and page breaks to the document.
    #
    module Breaks
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          def br
            contents << Caracal::Core::Models::LineBreakModel.new()
          end
          
          def page
            contents << Caracal::Core::Models::PageBreakModel.new()
          end
          
        end
      end
    end
    
  end
end
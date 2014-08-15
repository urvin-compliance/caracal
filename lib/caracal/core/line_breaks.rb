require 'caracal/core/models/line_break_model'


module Caracal
  module Core
    
    # This module encapsulates all the functionality related to adding line
    # breaks to the document.
    #
    module LineBreaks
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          def br
            contents << Caracal::Core::Models::LineBreakModel.new()
          end
          
        end
      end
    end
    
  end
end
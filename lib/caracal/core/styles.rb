module Caracal
  module Core
    
    # This module encapsulates all the functionality related to defining
    # styles.
    #
    module Styles
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Class Methods
          #-------------------------------------------------------------
          
          def self.default_styles
            []           
          end
          
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          def style(name, options= {}, &block)
          end
          
          def styles
            @styles ||= []
          end
          
        end
      end
    end
    
  end
end
require 'caracal/core/models/rule_model'
require 'caracal/errors'


module Caracal
  module Core
    
    # This module encapsulates all the functionality related to adding
    # horizontal rules to the document.
    #
    module Rules
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          def hr(**options, &block)
            model = Caracal::Core::Models::RuleModel.new(options, &block)
            
            if model.valid?
              contents << model
            else
              raise Caracal::Errors::InvalidModelError, 'Horizontal rules require non-zero :size and :spacing values.'
            end
          end
          
        end
      end
    end
    
  end
end
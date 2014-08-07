require 'caracal/core/models/list_model'
require 'caracal/errors'


module Caracal
  module Core
    
    # This module encapsulates all the functionality related to adding
    # horizontal rules to the document.
    #
    module Lists
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          def ol(**options, &block)
            options.merge!({ type: :ordered, level: 0 })
            
            model = Caracal::Core::Models::ListModel.new(options, &block)
            if model.valid?
              contents << model
            else
              raise Caracal::Errors::InvalidModelError, 'Ordered lists require at least one list item.'
            end
          end
          
          def ul(**options, &block)
            options.merge!({ type: :unordered, level: 0 })
            
            model = Caracal::Core::Models::ListModel.new(options, &block)
            if model.valid?
              contents << model
            else
              raise Caracal::Errors::InvalidModelError, 'Unordered lists require at least one list item.'
            end
          end
          
        end
      end
    end
    
  end
end
require 'caracal/core/models/image_model'
require 'caracal/errors'


module Caracal
  module Core
    
    # This module encapsulates all the functionality related to adding
    # images to the document.
    #
    module Images
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          def img(*args, &block)
            options = args.last.is_a?(Hash) ? args.pop : {}
            options.merge!({ url: args[0] }) if args[0]
            
            model = Caracal::Core::Models::ImageModel.new(options, &block)
            if model.valid?
              contents << model
            else
              raise Caracal::Errors::InvalidModelError, 'Images require an URL and positive size/margin values.'
            end
            model
          end
          
        end
      end
    end
    
  end
end
require 'caracal/core/models/table_model'
require 'caracal/errors'


module Caracal
  module Core
    
    # This module encapsulates all the functionality related to adding tables
    # to the document.
    #
    module Tables
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          def table(data, **options, &block)
            options.merge!({ data: data })
            
            model = Caracal::Core::Models::TableModel.new(options, &block)
            if model.valid?
              contents << model
            else
              raise Caracal::Errors::InvalidModelError, 'Tables must be provided at least one cell.'
            end
          end
          
        end
      end
    end
    
  end
end
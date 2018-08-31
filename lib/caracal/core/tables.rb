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
          
          def table(*args, &block)
            options = Caracal::Utilities.extract_options!(args)
            options.merge!({ data: args.first }) if args.first
            
            model = Caracal::Core::Models::TableModel.new(options, &block)
            if respond_to?(:page_width)
              container_width = page_width - page_margin_left - page_margin_right
              model.calculate_width(container_width)
            end
            
            if model.valid?
              if (previous = contents.last).is_a?(Caracal::Core::Models::TableModel)
                previous.leading_paragraph(false)
              end
              contents << model
            else
              raise Caracal::Errors::InvalidModelError, 'Table must be provided data for at least one cell.'
            end
            model
          end
          
        end
      end
    end
    
  end
end
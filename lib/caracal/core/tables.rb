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
            coerce_table_width(model)
            
            if model.valid?
              contents << model
            else
              raise Caracal::Errors::InvalidModelError, 'Table must be provided data for at least one cell.'
            end
          end
          
          
          #-------------------------------------------------------------
          # Private Methods
          #-------------------------------------------------------------
          
          # This method forces tables with no explicit width to an 
          # explicitly sized table equal to 100% of the available 
          # width.  
          # 
          # Duck-typing logic helps us determine whether we're being 
          # caled from the document root or from within a table cell. 
          # 
          def coerce_table_width(model)
            unless model.table_width
              if respond_to?(:page_width)
                width = (page_width - page_margin_left - page_margin_right)
              else                        
                width = (cell_width - cell_margin_left - cell_margin_right)
              end
              model.width width
            end
          end
          
        end
      end
    end
    
  end
end
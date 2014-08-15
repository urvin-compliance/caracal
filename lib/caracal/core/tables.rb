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
            if model.table_width.to_i <= 0
              model.width default_table_width(model)
            end
            
            if model.valid?
              contents << model
            else
              raise Caracal::Errors::InvalidModelError, 'Table must be provided data for at least one cell.'
            end
          end
          
          
          #-------------------------------------------------------------
          # Private Methods
          #-------------------------------------------------------------
          
          # This method determines a default table width of the maximum 
          # available width, in the event that no explicit width is 
          # provided.  
          # 
          # Duck-typing logic helps us determine whether we're being 
          # caled from the document root or from within a table cell. 
          # 
          def default_table_width(model)
            if respond_to?(:page_width)
              mars  = page_margin_left + page_margin_right
              width = page_width - mars
            else
              mars  = cell_margin_left + cell_margin_right
              bors  = model.table_border_left_total_size + model.table_border_right_total_size
              (model.cols().size - 1).times do
                bors += model.table_border_vertical_total_size
              end
              width = cell_width - mars - bors
            end
            width
          end
          
        end
      end
    end
    
  end
end
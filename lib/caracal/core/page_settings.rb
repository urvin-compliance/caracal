require 'caracal/core/models/margin_model'
require 'caracal/core/models/page_size_model'
require 'caracal/errors'


module Caracal
  module Core
    
    # This module encapsulates all the functionality related to setting the 
    # document's size and margins.
    #
    module PageSettings
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Configuration
          #-------------------------------------------------------------
    
          # accessors
          attr_reader :page_width
          attr_reader :page_height
          attr_reader :page_margin_top
          attr_reader :page_margin_bottom
          attr_reader :page_margin_left
          attr_reader :page_margin_right
          
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
    
          # This method controls the physical margins of the printed page. Defaults 
          # to 1in on each side.
          #
          def page_margins(options = {}, &block)
            model = Caracal::Core::Models::MarginModel.new(options, &block)

            if model.valid?
              if (model.margin_top + model.margin_bottom < page_height) && (model.margin_left + model.margin_right < page_width)
                @page_margin_top    = model.margin_top
                @page_margin_bottom = model.margin_bottom
                @page_margin_left   = model.margin_left
                @page_margin_right  = model.margin_right
              else
                raise Caracal::Errors::InvalidModelError, 'page_margins method requires margins to be smaller than the page size.'
              end
            else
              raise Caracal::Errors::InvalidModelError, 'page_margins method requires non-zero :top, :bottom, :left, and :right options.'
            end
          end
          
          # This method controls the physical width and height of the printed page. Defaults 
          # to US standard A4 portrait size.
          #
          def page_size(options = {}, &block)
            model = Caracal::Core::Models::PageSizeModel.new(options, &block)
            
            if model.valid?
              @page_width  = model.page_width
              @page_height = model.page_height
            else
              raise Caracal::Errors::InvalidModelError, 'page_size method requires non-zero :width and :height options.'
            end
          end
          
        end
      end
    end
    
  end
end
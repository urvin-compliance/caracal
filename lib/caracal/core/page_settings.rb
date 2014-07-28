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
    
          # constants
          const_set(:DEFAULT_PAGE_WIDTH,         12240)  # 8.5in  in twips
          const_set(:DEFAULT_PAGE_HEIGHT,        15840)  # 11.0in in twips
          const_set(:DEFAULT_PAGE_MARGIN_TOP,    1440)   # 1.0in  in twips
          const_set(:DEFAULT_PAGE_MARGIN_BOTTOM, 1440)   # 1.0in  in twips
          const_set(:DEFAULT_PAGE_MARGIN_LEFT,   1440)   # 1.0in  in twips
          const_set(:DEFAULT_PAGE_MARGIN_RIGHT,  1440)   # 1.0in  in twips
          
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
            if block_given?
              block_options = Caracal::Core::Models::PageMarginModel.new(&block).to_options
              options.merge! block_options
            end
            
            top    = (options[:top]    || page_margin_top    || self.class::DEFAULT_PAGE_MARGIN_TOP).to_i
            bottom = (options[:bottom] || page_margin_bottom || self.class::DEFAULT_PAGE_MARGIN_BOTTOM).to_i
            left   = (options[:left]   || page_margin_left   || self.class::DEFAULT_PAGE_MARGIN_LEFT).to_i
            right  = (options[:right]  || page_margin_right  || self.class::DEFAULT_PAGE_MARGIN_RIGHT).to_i
            
            if top > 0 && bottom > 0 && left > 0 && right > 0
              if (top + bottom < page_height) && (left + right < page_width)
                @page_margin_top    = top
                @page_margin_bottom = bottom
                @page_margin_left   = left
                @page_margin_right  = right
              else
                raise Caracal::Errors::InvalidPageSetting, 'page_margins method requires margins to be smaller than the page size.'
              end
            else
              raise Caracal::Errors::InvalidPageSetting, 'page_margins method requires non-zero :top, :bottom, :left, and :right options.'
            end
          end
          
          # This method controls the physical width and height of the printed page. Defaults 
          # to US standard A4 portrait size.
          #
          def page_size(options = {}, &block)
            if block_given?
              block_options = Caracal::Core::Models::PageSizeModel.new(&block).to_options
              options.merge! block_options
            end
            
            width  = (options[:width]  || page_width  || self.class::DEFAULT_PAGE_WIDTH).to_i
            height = (options[:height] || page_height || self.class::DEFAULT_PAGE_HEIGHT).to_i
            
            if width > 0 && height > 0
              @page_width  = width
              @page_height = height
            else
              raise Caracal::Errors::InvalidPageSetting, 'page_size method requires non-zero :width and :height options.'
            end
          end
          
        end
      end
    end
    
  end
end
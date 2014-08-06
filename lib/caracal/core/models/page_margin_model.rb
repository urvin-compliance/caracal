module Caracal
  module Core
    module Models
      
      # This class handles block options passed to the page margins
      # method.
      #
      class PageMarginModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # constants
        const_set(:DEFAULT_PAGE_MARGIN_TOP,    1440)  # 1.0in in twips
        const_set(:DEFAULT_PAGE_MARGIN_BOTTOM, 1440)  # 1.0in in twips
        const_set(:DEFAULT_PAGE_MARGIN_LEFT,   1440)  # 1.0in in twips
        const_set(:DEFAULT_PAGE_MARGIN_RIGHT,  1440)  # 1.0in in twips
        
        # accessors
        attr_reader :page_margin_top
        attr_reader :page_margin_bottom
        attr_reader :page_margin_left
        attr_reader :page_margin_right
        
        
        # initialization
        def initialize(**options, &block)
          options.each do |(key, value)|
            send(key, value)
          end
          
          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          end
          
          @page_margin_top    ||= DEFAULT_PAGE_MARGIN_TOP
          @page_margin_bottom ||= DEFAULT_PAGE_MARGIN_BOTTOM
          @page_margin_left   ||= DEFAULT_PAGE_MARGIN_LEFT
          @page_margin_right  ||= DEFAULT_PAGE_MARGIN_RIGHT
        end
        
        
        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
        
        #=============== SETTERS ==============================
        
        def bottom(value)
          @page_margin_bottom = value.to_i
        end
        
        def left(value)
          @page_margin_left = value.to_i
        end
        
        def right(value)
          @page_margin_right = value.to_i
        end
        
        def top(value)
          @page_margin_top = value.to_i
        end
        
        
        #=============== VALIDATION ==============================
        
        def valid?
          dims = [page_margin_top, page_margin_bottom, page_margin_left, page_margin_right]
          dims.all? { |d| d > 0 }
        end
        
      end
      
    end
  end
end
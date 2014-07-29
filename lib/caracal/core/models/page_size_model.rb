module Caracal
  module Core
    module Models
      
      # This class handles block options passed to the page size
      # method.
      #
      class PageSizeModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # constants
        const_set(:DEFAULT_PAGE_WIDTH,  12240)  # 8.5in  in twips
        const_set(:DEFAULT_PAGE_HEIGHT, 15840)  # 11.0in in twips
        
        # accessors
        attr_reader :page_width
        attr_reader :page_height
        
        # initialization
        def initialize(options = {}, &block)
          options.each do |(key, value)|
            send(key, value)
          end
          
          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          end
          
          @page_width  ||= DEFAULT_PAGE_WIDTH
          @page_height ||= DEFAULT_PAGE_HEIGHT
        end
        
        
        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
    
        #=============== SETTERS ==============================
        
        def height(value)
          @page_height = value.to_i
        end
        
        def width(value)
          @page_width = value.to_i
        end
        
        
        #=============== VALIDATION ==============================
        
        def valid?
          dims = [page_width, page_height]
          dims.all? { |d| d > 0 }
        end
        
      end
      
    end
  end
end
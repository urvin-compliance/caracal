module Caracal
  module Core
    module Models
      
      # This class handles block options passed to the page margins
      # method.
      #
      class PageMarginModel
        
        # accessors
        attr_accessor :page_margin_top
        attr_accessor :page_margin_bottom
        attr_accessor :page_margin_left
        attr_accessor :page_margin_right
        
        # initialization
        def initialize(&block)
          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          else
            raise Caracal::Errors::NoBlockGivenError, 'PageMarginModel must be passed a block.'
          end
        end
        
        # top
        def top(value)
          @page_margin_top = value.to_i
        end
        
        # bottom
        def bottom(value)
          @page_margin_bottom = value.to_i
        end
        
        # left
        def left(value)
          @page_margin_left = value.to_i
        end
        
        # right
        def right(value)
          @page_margin_right = value.to_i
        end
        
        # to_options
        def to_options
          opts = { 
            top:    page_margin_top, 
            bottom: page_margin_bottom, 
            left:   page_margin_left, 
            right:  page_margin_right 
          }
          opts.delete_if { |k, v| v.nil? }
        end
        
      end
      
    end
  end
end
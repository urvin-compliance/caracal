module Caracal
  module Core
    module Models
      
      # This class handles block options passed to the page size
      # method.
      #
      class PageSizeModel
        
        # accessors
        attr_accessor :page_width
        attr_accessor :page_height
        
        # initialization
        def initialize(&block)
          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          else
            raise Caracal::Errors::NoBlockGivenError, 'PageSizeModel must be passed a block.'
          end
        end
        
        # width
        def width(value)
          @page_width = value.to_i
        end
        
        # height
        def height(value)
          @page_height = value.to_i
        end
        
        # to_options
        def to_options
          opts = { 
            width:  page_width, 
            height: page_height 
          }
          opts.delete_if { |k, v| v.nil? }
        end
        
      end
      
    end
  end
end
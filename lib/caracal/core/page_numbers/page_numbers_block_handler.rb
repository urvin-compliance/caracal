module Caracal
  module Core
    module PageNumbers
      
      # This class handles block options passed to the page_numbers
      # method.
      #
      class PageNumbersBlockHandler
        
        # accessors
        attr_accessor :number_align
        
        # initialization
        def initialize(&block)
          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          else
            raise Caracal::Errors::NoBlockGivenError, 'PageNumbersBlockHandler must be passed a block.'
          end
        end
        
        # align
        def align(value)
          @number_align = value.to_s.to_sym
        end
        
        # to_options
        def to_options
          opts = { 
            align:  number_align 
          }
          opts.delete_if { |k, v| v.nil? }
        end
        
      end
      
    end
  end
end
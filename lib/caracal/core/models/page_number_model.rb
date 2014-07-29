module Caracal
  module Core
    module Models
      
      # This class handles block options passed to the page_numbers
      # method.
      #
      class PageNumberModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # constants
        const_set(:DEFAULT_PAGE_NUMBER_ALIGN, :center)
        
        # accessors
        attr_accessor :page_number_align
        attr_accessor :page_number_show
        
        # initialization
        def initialize(options = {}, &block)
          options.each do |(key, value)|
            send(key, value)
          end
          
          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          end
          
          unless [:left, :center, :right].include?(page_number_align)
            if page_number_show
              raise Caracal::Errors::InvalidPageNumberError, 'page_numbers :align parameter must be :left, :center, or :right'
            else
              align DEFAULT_PAGE_NUMBER_ALIGN
            end
          end
        end
        
        
        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
    
        #=============== SETTERS ==============================
        
        def align(value)
          @page_number_align = value.to_s.to_sym
        end
        
        def show(value)
          @page_number_show = !!value
        end
        
      end
      
    end
  end
end
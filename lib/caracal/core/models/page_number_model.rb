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
        const_set(:DEFAULT_PAGE_NUMBER_SHOW,  false)
        const_set(:DEFAULT_PAGE_NUMBER_ALIGN, :center)
        
        # accessors
        attr_reader :page_number_align
        attr_reader :page_number_show
        
        # initialization
        def initialize(**options, &block)
          options.each do |(key, value)|
            send(key, value)
          end
          
          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          end
          
          @page_number_show  ||= DEFAULT_PAGE_NUMBER_SHOW
          @page_number_align ||= DEFAULT_PAGE_NUMBER_ALIGN
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
        
        
        #=============== VALIDATION ===========================
        
        def valid?
          (!page_number_show || [:left, :center, :right].include?(page_number_align))
        end
        
        
        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private
        
        def option_keys
          [:align, :show]
        end
        
      end
      
    end
  end
end
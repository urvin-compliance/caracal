require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models
      
      # This class handles block options passed to the page_numbers
      # method.
      #
      class PageNumberModel < BaseModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # constants
        const_set(:DEFAULT_PAGE_NUMBER_SHOW,  false)
        const_set(:DEFAULT_PAGE_NUMBER_ALIGN, :center)
        
        # accessors
        attr_reader :page_number_text
        attr_reader :page_number_align
        attr_reader :page_number_show
        
        # initialization
        def initialize(options={}, &block)
          @page_number_text = nil
          @page_number_show  = DEFAULT_PAGE_NUMBER_SHOW
          @page_number_align = DEFAULT_PAGE_NUMBER_ALIGN
          
          super options, &block
        end
        
        
        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
    
        #=============== SETTERS ==============================

        def text(value)
          @page_number_text = value.to_s
        end

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
          [:text, :align, :show]
        end
        
      end
      
    end
  end
end
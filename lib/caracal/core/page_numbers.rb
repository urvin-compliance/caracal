module Caracal
  module Core
    
    # This module encapsulates all the functionality related to setting the 
    # document's page number behavior.
    #
    module PageNumbers
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Configuration
          #-------------------------------------------------------------
    
          # constants
          const_set(:DEFAULT_PAGE_NUMBER_ALIGN,  :center)
          
          # accessors
          attr_reader :page_number_show
          attr_reader :page_number_align
          
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
    
          # This method controls whether and how page numbers are displayed
          # on the document.
          #
          def page_numbers(show = nil, options = {}, &block)
            options.merge!({ show: !!show })
            model = Caracal::Core::Models::PageNumberModel.new(options, &block)
            
            @page_number_show  = model.page_number_show  || !!page_number_show
            @page_number_align = model.page_number_align || page_number_align
          end
          
        end
      end
    end
    
  end
end
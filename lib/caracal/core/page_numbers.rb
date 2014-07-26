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
    
          # This method controls the physical margins of the printed page. Defaults 
          # to 1in on each side.
          #
          def page_numbers(show = false, options = {}, &block)
            if block_given?
              block_options = PageNumbersBlockHandler.new(&block).to_options
              options.merge! block_options
            end
            
            show  = !!show   # coerce to boolean
            align = (options[:align] || page_number_align || self.class::DEFAULT_PAGE_NUMBER_ALIGN).to_s.to_sym
            
            unless [:left, :center, :right].include? align
              if show
                raise Caracal::Errors::InvalidPageNumberError, 'page_numbers :align parameter must be :left, :center, or :right'
              else
                align = :center
              end
            end
            
            @page_number_show  = show
            @page_number_align = align
          end
          
        end
      end
    end
    
  end
end
module Caracal
  module Core
    
    # This module encapsulates all the functionality related to setting the 
    # document's name.
    #
    module FileName
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Configuration
          #-------------------------------------------------------------
    
          # constants
          const_set(:DEFAULT_FILE_NAME, 'caracal.docx')
          
          # accessors
          attr_reader :name
          
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
    
          # This method sets the name of the output file. Defaults
          # to the name of the library.
          #
          def file_name(value = nil)
            v = value.to_s.strip
            @name = (v == '') ? self.class::DEFAULT_FILE_NAME : v
          end
          
        end
      end
    end
    
  end
end
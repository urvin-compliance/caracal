module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed for functions that 
      # do not store or manipulate data.
      #
      class NullModel
        
        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------
    
        #=============== VALIDATION ===========================
        
        def valid?
          true
        end
        
      end
      
    end
  end
end
module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed for functions that 
      # do not store or manipulate data.
      #
      class BaseModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
    
        # initialization
        def initialize(**options, &block)
          options.keep_if { |k,v| option_keys.include? k }
          options.each do |(key, value)|
            send(key, value)
          end
          
          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          end
        end
        
        
        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------
    
        #=============== VALIDATION ===========================
        
        def valid?
          true
        end
        
        
        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private
        
        def option_keys
          []
        end
        
      end
      
    end
  end
end
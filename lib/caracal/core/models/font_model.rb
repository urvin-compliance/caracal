module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed to store and manipulate
      # font data.
      #
      class FontModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
    
        # accessors
        attr_reader :font_name
        
        # initialization
        def initialize(**options, &block)
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
    
        #=============== SETTERS ==============================
        
        def name(value)
          @font_name = value.to_s
        end
        
        
        #=============== STATE ================================
        
        def matches?(str)
          font_name.downcase == str.to_s.downcase
        end
        
        
        #=============== VALIDATION ===========================
        
        def valid?
          !font_name.nil?
        end
        
      end
      
    end
  end
end
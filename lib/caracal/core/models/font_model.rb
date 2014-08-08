require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed to store and manipulate
      # font data.
      #
      class FontModel < BaseModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # accessors
        attr_reader :font_name
        
        
        
        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------
    
        #=============== SETTERS ==============================
        
        # strings
        [:name].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@font_#{ m }", value.to_s)
          end
        end
        
        
        #=============== STATE ================================
        
        def matches?(str)
          font_name.to_s.downcase == str.to_s.downcase
        end
        
        
        #=============== VALIDATION ===========================
        
        def valid?
          a = [:name]
          a.map { |m| send("font_#{ m }") }.compact.size == a.size
        end
        
        
        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private
        
        def option_keys
          [:name]
        end
        
      end
      
    end
  end
end
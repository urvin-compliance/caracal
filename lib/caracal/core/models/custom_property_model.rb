require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # custom properties
      #
      class CustomPropertyModel < BaseModel

        # accessors
        attr_reader :custom_property_name
        attr_reader :custom_property_value
        attr_reader :custom_property_type


        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------


        #=================== SETTERS =============================

        def name(value)
          @custom_property_name = value.to_s
        end

        def value(value)
          @custom_property_value = value.to_s
        end

        def type(value)
          @custom_property_type = value.to_s
        end


        #=============== VALIDATION ===========================

        def valid?
          required = option_keys
          required.all? { |m| !send("custom_property_#{ m }").nil? }
        end

        
        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private

        def option_keys
          [:name, :value, :type]
        end

      end

    end
  end
end

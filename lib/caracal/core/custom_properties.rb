require 'caracal/core/models/custom_property_model'
require 'caracal/errors'


module Caracal
  module Core

    # This module encapsulates all the functionality related to setting the
    # document's custom properties.
    #
    module CustomProperties
      def self.included(base)
        base.class_eval do

          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          # This method controls the custom properties.
          #
          def custom_property(options={}, &block)
            model = Caracal::Core::Models::CustomPropertyModel.new(options, &block)
            if model.valid?
              register_property(model)
            end
            model
          end


          #============== GETTERS =============================

          def custom_props
            @custom_props ||= []
          end


          #============== REGISTRATION ========================

          def register_property(model)
            custom_props << model
            model
          end

        end
      end
    end

  end
end

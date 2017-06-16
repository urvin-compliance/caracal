require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # namespace data.
      #
      class NamespaceModel < BaseModel

        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------

        # accessors
        attr_reader :namespace_prefix
        attr_reader :namespace_href



        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------

        #=================== SETTERS =============================

        # strings
        [:href, :prefix].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@namespace_#{ m }", value.to_s)
          end
        end


        #=================== STATE ===============================

        def matches?(str)
          namespace_prefix == str.to_s
        end


        #=============== VALIDATION ===========================

        def valid?
          required = [:href, :prefix]
          required.all? { |m| !send("namespace_#{ m }").nil? }
        end


        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private

        def option_keys
          [:prefix, :href]
        end

      end

    end
  end
end

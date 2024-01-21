require 'caracal/core/models/header_model'
require 'caracal/errors'


module Caracal
  module Core

    # This module encapsulates all the functionality related to adding a header
    # to every page of the document.
    #
    module Header
      def self.included(base)
        base.class_eval do

          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          def header(*args, &block)
            options = Caracal::Utilities.extract_options!(args)

            model = Caracal::Core::Models::HeaderModel.new(options, &block)

            @header_content = model

            model
          end
        end
      end
    end
  end
end

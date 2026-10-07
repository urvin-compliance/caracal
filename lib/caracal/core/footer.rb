require 'caracal/core/models/footer_model'
require 'caracal/errors'


module Caracal
  module Core

    # This module encapsulates all the functionality related to adding a
    # footer on every page of the document.
    #
    module Footer
      def self.included(base)
        base.class_eval do

          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          def footer(*args, &block)
            options = Caracal::Utilities.extract_options!(args)

            model = Caracal::Core::Models::FooterModel.new(options, &block)
            if model.valid?
              @footer_content = model
            else
              raise Caracal::Errors::InvalidModelError, 'footer must contain at least one paragraph, list, table, rule or image.'
            end
            model
          end

          def footer_content
            @footer_content
          end

        end
      end
    end
  end
end

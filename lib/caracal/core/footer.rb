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

          # With `first: true` the footer replaces the default one on the
          # first page only. Without a block it leaves the first page's
          # footer blank.
          #
          def footer(*args, &block)
            options = Caracal::Utilities.extract_options!(args)
            first   = options.delete(:first)

            model = Caracal::Core::Models::FooterModel.new(options, &block)
            if first
              @first_footer_content = model
            elsif model.valid?
              @footer_content = model
            else
              raise Caracal::Errors::InvalidModelError, 'footer must contain at least one paragraph, list, table, rule or image.'
            end
            model
          end

          def footer_content
            @footer_content
          end

          def first_footer_content
            @first_footer_content
          end

        end
      end
    end
  end
end

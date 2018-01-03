require 'caracal/core/models/page_number_model'
require 'caracal/errors'


module Caracal
  module Core

    # This module encapsulates all the functionality related to setting the
    # document's page number behavior.
    #
    module PageNumbers
      def self.included(base)
        base.class_eval do

          #-------------------------------------------------------------
          # Configuration
          #-------------------------------------------------------------

          # constants
          const_set(:DEFAULT_PAGE_NUMBER_ALIGN,  :center)

          # accessors
          attr_reader :page_number_align
          attr_reader :page_number_label
          attr_reader :page_number_show
          attr_reader :page_number_label_size


          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          # This method controls whether and how page numbers are displayed
          # on the document.
          #
          def page_numbers(*args, &block)
            options = Caracal::Utilities.extract_options!(args)
            options.merge!({ show: !!args.first }) unless args.first.nil?  # careful: falsey value

            model = Caracal::Core::Models::PageNumberModel.new(options, &block)
            if model.valid?
              @page_number_align = model.page_number_align
              @page_number_label = model.page_number_label
              @page_number_show  = model.page_number_show
              @page_number_label_size = model.page_number_label_size
            else
              raise Caracal::Errors::InvalidModelError, 'page_numbers :align parameter must be :left, :center, or :right'
            end
          end

        end
      end
    end

  end
end

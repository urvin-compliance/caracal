require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class handles block options passed to the page_numbers
      # method.
      #
      class PageNumberModel < BaseModel

        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------

        # constants
        const_set(:DEFAULT_PAGE_NUMBER_ALIGN, :center)
        const_set(:DEFAULT_PAGE_NUMBER_SHOW,  false)

        # accessors
        attr_reader :page_number_align
        attr_reader :page_number_label
        attr_reader :page_number_label_size
        attr_reader :page_number_number_size
        attr_reader :page_number_show
        attr_reader :page_number_first
        attr_reader :page_number_start

        # initialization
        def initialize(options={}, &block)
          @page_number_align        = DEFAULT_PAGE_NUMBER_ALIGN
          @page_number_label        = nil
          @page_number_label_size   = nil
          @page_number_number_size  = nil
          @page_number_show         = DEFAULT_PAGE_NUMBER_SHOW
          @page_number_first        = true
          @page_number_start        = nil

          super options, &block
        end


        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------

        #=============== SETTERS ==============================

        def align(value)
          @page_number_align = value.to_s.to_sym
        end

        def label(value)
          @page_number_label = value.to_s.strip   # renderer will enforce trailing space
        end

        def label_size(value)
          v = value.to_i
          @page_number_label_size = (v == 0) ? nil : v
        end

        def number_size(value)
          v = value.to_i
          @page_number_number_size = (v == 0) ? nil : v
        end

        def show(value)
          @page_number_show = !!value
        end

        # false leaves the page number off the first page
        def first_page(value)
          @page_number_first = !!value
        end

        def start(value)
          @page_number_start = value.nil? ? nil : value.to_i
        end

        def size(value)
          v = value.to_i
          @page_number_label_size  = (v == 0) ? nil : v
          @page_number_number_size = (v == 0) ? nil : v
        end


        #=============== VALIDATION ===========================

        def valid?
          valid_align = (!page_number_show || [:left, :center, :right].include?(page_number_align))
          valid_start = (page_number_start.nil? || page_number_start >= 0)
          valid_align && valid_start
        end


        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private

        def option_keys
          [:align, :label, :label_size, :number_size, :show, :size, :start, :first_page]
        end

      end

    end
  end
end

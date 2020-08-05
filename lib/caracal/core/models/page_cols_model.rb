require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class handles block options passed to the page size
      # method.
      #
      class PageColsModel < BaseModel

        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------

        # constants
        const_set(:DEFAULT_PAGE_COLS_NUM,          1)
        const_set(:DEFAULT_PAGE_COLS_SPACE,    15840)

        # accessors
        attr_reader :page_cols_num
        attr_reader :page_cols_space

        # initialization
        def initialize(options={}, &block)
          @page_cols_num        = DEFAULT_PAGE_COLS_NUM
          @page_cols_space      = DEFAULT_PAGE_COLS_SPACE

          super options, &block
        end


        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------

        #=============== SETTERS ==============================

        def cols(value)
          @page_cols_num = value.to_i
        end

        def space(value)
          @page_cols_space = value.to_i
        end


        #=============== VALIDATION ==============================

        def valid?
          dims = [page_width, page_height]
          dims.all? { |d| d > 0 }
        end


        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private

        def option_keys
          [:num, :space]
        end

      end

    end
  end
end

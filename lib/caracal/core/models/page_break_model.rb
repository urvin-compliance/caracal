require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # page break data.
      #
      # The :wrap option is not described in the project's README because
      # it exists purely as an internal Caracal concern. Page breaks
      # at the document level must be wrapped in a paragraph node; page breaks
      # within paragraph-like container simply add a run.  There's no need to
      # trouble end users with this issue.
      #
      class PageBreakModel < BaseModel

        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------

        # constants
        const_set(:DEFAULT_PAGE_BREAK_WRAP, true)

        # accessors
        attr_reader :page_break_wrap

        # initialization
        def initialize(options={}, &block)
          @page_break_wrap = DEFAULT_PAGE_BREAK_WRAP

          super options, &block
        end


        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------

        #=============== SETTERS ==============================

        def wrap(value)
          @page_break_wrap = !!value
        end


        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private

        def option_keys
          [:wrap]
        end

      end

    end
  end
end

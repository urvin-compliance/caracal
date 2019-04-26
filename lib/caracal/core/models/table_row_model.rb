require 'caracal/core/models/base_model'
require 'caracal/core/models/border_model'
require 'caracal/core/models/table_cell_model'


module Caracal
  module Core
    module Models

      # This class handles block options passed to tables via their data
      # collections.
      #
      class TableRowModel < BaseModel

        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------

        # constants
        const_set(:HEIGHT_CALCULATION_TYPES,   [ :auto, :at_least, :exact])
        const_set(:DEFAULT_KEEP_TOGETHER,      false)
        const_set(:DEFAULT_HEIGHT,             250)
        const_set(:DEFAULT_HEIGHT_CALCULATION, :auto)

        # accessors
        attr_reader :row_keep_together
        attr_reader :row_height


        # initialization
        def initialize(options={}, &block)
          @row_keep_together      = DEFAULT_KEEP_TOGETHER
          @row_height             = DEFAULT_HEIGHT
          @row_height_calculation = DEFAULT_HEIGHT_CALCULATION

          super options, &block
        end


        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------

        #=============== DATA ACCESSORS =======================

        def cells
          @cells ||= []
        end


        #=============== STYLES ===============================

        # This method allows styles to be applied to this row
        # from the table level.  It attempts to add the style
        # to this row
        #
        # In all cases, invalid options will simply be ignored.
        #
        def apply_styles(opts={})
          # make dup of options so we don't
          # harm args sent to sibling rows
          options = opts.dup

          # data_row is not a style
          allowed_keys = option_keys.drop(1)

          # first, try apply to self
          options.each do |(k,v)|
            send(k, v)  if allowed_keys.include?(k)
          end
        end

        #=============== GETTERS ==============================

        def row_height_calculation
          Caracal::Utilities.camel_case_lower(@row_height_calculation)
        end

        #=============== SETTERS ==============================

        # integers
        [:height].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@row_#{ m }", value.to_i)
          end
        end

        # booleans
        [:keep_together].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set( "@row_#{ m }", !!value)
          end
        end

        def height_calculation(value)
          @row_height_calculation = value if HEIGHT_CALCULATION_TYPES.include?(value)
        end

        # .data_row
        def data_row(value)
          @cells = value.map do |data_cell|
            case data_cell
            when Caracal::Core::Models::TableCellModel
              data_cell
            when Hash
              Caracal::Core::Models::TableCellModel.new(data_cell)
            when Proc
              Caracal::Core::Models::TableCellModel.new(&data_cell)
            else
              Caracal::Core::Models::TableCellModel.new({ content: data_cell.to_s })
            end
          end
        end

        #=============== VALIDATION ===========================

        def valid?
          cells.size > 0
        end


        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private

        def option_keys
          [:data_row, :keep_together, :height, :height_calculation]
        end

      end

    end
  end
end

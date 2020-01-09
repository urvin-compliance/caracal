require 'caracal/core/models/base_model'
require 'caracal/core/models/border_model'
require 'caracal/core/models/table_cell_model'


module Caracal
  module Core
    module Models
      
      # This class handles block options passed to the table
      # method.
      #
      class TableModel < BaseModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # constants
        const_set(:DEFAULT_TABLE_ALIGN,             :center)    # weirdly, works better w/ full width
        const_set(:DEFAULT_TABLE_BORDER_COLOR,      'auto')
        const_set(:DEFAULT_TABLE_BORDER_LINE,       :single)
        const_set(:DEFAULT_TABLE_BORDER_SIZE,       0)          # units in 1/8 points
        const_set(:DEFAULT_TABLE_BORDER_SPACING,    0)  
        const_set(:DEFAULT_TABLE_HEADER_ROWS,       0)     
        
        # accessors
        attr_reader :table_align
        attr_reader :table_width
        attr_reader :table_border_color
        attr_reader :table_border_line
        attr_reader :table_border_size
        attr_reader :table_border_spacing
        attr_reader :table_border_top         # returns border model
        attr_reader :table_border_bottom      # returns border model
        attr_reader :table_border_left        # returns border model
        attr_reader :table_border_right       # returns border model
        attr_reader :table_border_horizontal  # returns border model
        attr_reader :table_border_vertical    # returns border model
        attr_reader :table_header_rows
        
        # initialization
        def initialize(options={}, &block)
          @table_align          = DEFAULT_TABLE_ALIGN
          @table_border_color   = DEFAULT_TABLE_BORDER_COLOR
          @table_border_line    = DEFAULT_TABLE_BORDER_LINE
          @table_border_size    = DEFAULT_TABLE_BORDER_SIZE
          @table_border_spacing = DEFAULT_TABLE_BORDER_SPACING
          @table_header_rows    = DEFAULT_TABLE_HEADER_ROWS
          
          super options, &block
        end
        
        
        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
        
        #=============== DATA ACCESSORS =======================
        
        def cells
          rows.flatten
        end
        
        def cols
          rows.reduce([]) do |array, row|
            row.each_with_index do |cell, index|
              array[index]  = []    if array[index].nil?
              array[index] << cell
            end
            array
          end
        end
        
        def rows
          @table_data || [[]]
        end
        
        
        #=============== STYLES ===============================
        
        # This method sets explicit widths on all wrapped cells
        # that do not already have widths asided.
        #
        def calculate_width(container_width)
          width(container_width) unless table_width.to_i > 0
          
          cells.each { |c| c.calculate_width(default_cell_width) }
        end
        
        # This method allows tables to be styled several cells 
        # at a time.
        #
        # For example, this would style a header row.
        #
        # docx.table data do |t|
        #   t.cell_style t.rows[0], background: '3366cc', color: 'ffffff', bold: true
        # end
        #
        def cell_style(models, options={})
          [models].flatten.compact.each do |m|
            m.apply_styles(options)
          end  
        end
        
        
        #=============== GETTERS ==============================
        
        # border attrs
        [:top, :bottom, :left, :right, :horizontal, :vertical].each do |m|
          [:color, :line, :size, :spacing].each do |attr|
            define_method "table_border_#{ m }_#{ attr }" do
              model = send("table_border_#{ m }")
              value = (model) ? model.send("border_#{ attr }") : send("table_border_#{ attr }")
            end
          end
          define_method "table_border_#{ m }_total_size" do
            model = send("table_border_#{ m }")
            value = (model) ? model.total_size : table_border_size + (2 * table_border_spacing)
          end
        end
        
        
        #=============== SETTERS ==============================
        
        # integers
        [:border_size, :border_spacing, :header_rows, :width].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@table_#{ m }", value.to_i)
          end
        end
        
        # models
        [:top, :bottom, :left, :right, :horizontal, :vertical].each do |m|
          define_method "border_#{ m }" do |options = {}, &block|
            options.merge!({ type: m })
            instance_variable_set("@table_border_#{ m }", Caracal::Core::Models::BorderModel.new(options, &block))
          end
        end
        
        # strings
        [:border_color].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@table_#{ m }", value.to_s)
          end
        end
        
        # symbols
        [:border_line, :align].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@table_#{ m }", value.to_s.to_sym)
          end
        end
        
        # .data
        def data(value)
          begin
            @table_data = value.map do |data_row|
              data_row.map do |data_cell|
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
          rescue
            raise Caracal::Errors::InvalidTableDataError, 'Table data must be a two-dimensional array.'
          end
        end        
        
        
        #=============== VALIDATION ==============================
        
        def valid?
          cells.first.is_a?(Caracal::Core::Models::TableCellModel)
        end
        
        
        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private
        
        def default_cell_width
          cell_widths     = rows.first.map { |c| c.cell_width.to_i }
          remaining_width = table_width - cell_widths.reduce(&:+).to_i
          remaining_cols  = cols.size - cell_widths.reject { |w| w == 0 }.size
          default_width   = (remaining_cols == 0) ? 0 : (remaining_width / remaining_cols)
        end
        
        def option_keys
          k = []
          k << [:data, :align, :width]
          k << [:border_color, :border_line, :border_size, :border_spacing]
          k << [:border_bottom, :border_left, :border_right, :border_top, :border_horizontal, :border_vertical]
          k.flatten
        end
        
      end
      
    end
  end
end
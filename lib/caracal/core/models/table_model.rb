require 'caracal/core/models/base_model'


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
        const_set(:DEFAULT_TABLE_ALIGN,          :left)
        const_set(:DEFAULT_TABLE_BORDER_COLOR,   'auto')
        const_set(:DEFAULT_TABLE_BORDER_LINE,    :single)
        const_set(:DEFAULT_TABLE_BORDER_SIZE,    0)          # units in 1/8 points
        const_set(:DEFAULT_TABLE_BORDER_SPACING, 0)          
        
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
        
        # initialization
        def initialize(**options, &block)
          super options, &block
          
          @table_align          ||= DEFAULT_TABLE_ALIGN
          @table_border_color   ||= DEFAULT_TABLE_BORDER_COLOR
          @table_border_line    ||= DEFAULT_TABLE_BORDER_LINE
          @table_border_size    ||= DEFAULT_TABLE_BORDER_SIZE
          @table_border_spacing ||= DEFAULT_TABLE_BORDER_SPACING
        end
        
        
        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
        
        #=============== GETTERS ==============================
        
        def cells
          @table_data || [[]]
        end
        
        [:top, :bottom, :left, :right, :horizontal, :vertical].each do |m|
          [:color, :line, :size, :spacing].each do |attr|
            define_method "table_border_#{ m }_#{ attr }" do
              model = send("table_border_#{ m }")
              value = (model) ? model.send("border_#{ attr }") : send("table_border_#{ attr }")
            end
          end
        end
        
        
        #=============== SETTERS ==============================
        
        # borders
        [:top, :bottom, :left, :right, :horizontal, :vertical].each do |m|
          define_method "border_#{ m }" do |**options, &block|
            instance_variable_set("@table_border_#{ m }", Caracal::Core::Models::BorderModel.new(options, &block))
          end
        end
        
        # integers
        [:border_size, :border_spacing, :width].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@table_#{ m }", value.to_i)
          end
        end
        
        # objects
        [:data].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@table_#{ m }", value)
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
        
        
        #=============== VALIDATION ==============================
        
        def valid?
          !cells[0][0].nil?
        end
        
        
        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private
        
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
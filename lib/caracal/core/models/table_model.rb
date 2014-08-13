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
        const_set(:DEFAULT_TABLE_ALIGN,        :left)
        const_set(:DEFAULT_TABLE_BORDER_COLOR, '333333')
        const_set(:DEFAULT_TABLE_BORDER_SIZE,  4)          # 0.5pt in 1/8 points
        
        # accessors
        attr_reader :table_align
        attr_reader :table_border_color
        attr_reader :table_border_size
        attr_reader :table_width
        
        
        # initialization
        def initialize(**options, &block)
          super options, &block
          
          @table_align        ||= DEFAULT_TABLE_ALIGN
          @table_border_color ||= DEFAULT_TABLE_BORDER_COLOR
          @table_border_size  ||= DEFAULT_TABLE_BORDER_SIZE
        end
        
        
        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
        
        #=============== GETTERS ==============================
        
        def table_data
          @table_data || [[]]
        end
        
        
        #=============== SETTERS ==============================
        
        # integers
        [:border_size, :width].each do |m|
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
        [:align].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@table_#{ m }", value.to_s.to_sym)
          end
        end
        
        
        #=============== VALIDATION ==============================
        
        def valid?
          !table_data[0][0].nil?
        end
        
        
        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private
        
        def option_keys
          [:align, :border_color, :border_size, :data, :width]
        end
        
      end
      
    end
  end
end
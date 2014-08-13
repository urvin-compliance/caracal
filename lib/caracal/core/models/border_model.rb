require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models
      
      # This class handles block options passed to the page margins
      # method.
      #
      class BorderModel < BaseModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # constants
        const_set(:DEFAULT_BORDER_COLOR,    'auto')
        const_set(:DEFAULT_BORDER_SIZE,     4)        # 0.5pt in 1/8 points
        const_set(:DEFAULT_BORDER_SPACING,  1)        # 0.125pt in 1/8 points
        const_set(:DEFAULT_BORDER_LINE,     :single) 
        
        # accessors
        attr_reader :border_color
        attr_reader :border_size
        attr_reader :border_spacing
        attr_reader :border_line
        
        
        # initialization
        def initialize(**options, &block)
          super options, &block
          
          @border_color   ||= DEFAULT_BORDER_COLOR
          @border_size    ||= DEFAULT_BORDER_SIZE
          @border_spacing ||= DEFAULT_BORDER_SPACING
          @border_line    ||= DEFAULT_BORDER_LINE
        end
        
        
        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
        
        #=============== SETTERS ==============================
        
        # integers
        [:size, :spacing].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@border_#{ m }", value.to_i)
          end
        end
        
        # strings
        [:color].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@border_#{ m }", value.to_s)
          end
        end
        
        # symbols
        [:line].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@border_#{ m }", value.to_s.to_sym)
          end
        end
        
        
        #=============== VALIDATION ==============================
        
        def valid?
          dims = [border_size, border_spacing]
          dims.all? { |d| d > 0 }
        end
        
        
        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private
        
        def option_keys
          [:color, :size, :spacing, :line]
        end
        
      end
      
    end
  end
end
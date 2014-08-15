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
        const_set(:DEFAULT_BORDER_LINE,     :single) 
        const_set(:DEFAULT_BORDER_SIZE,     4)        # 0.5pt in 1/8 points
        const_set(:DEFAULT_BORDER_SPACING,  1)        # 0.125pt in 1/8 points
        const_set(:DEFAULT_BORDER_TYPE,     :top)
        
        # accessors
        attr_reader :border_color
        attr_reader :border_line
        attr_reader :border_size
        attr_reader :border_spacing
        attr_reader :border_type
        
        # initialization
        def initialize(**options, &block)
          @border_color   = DEFAULT_BORDER_COLOR
          @border_line    = DEFAULT_BORDER_LINE
          @border_size    = DEFAULT_BORDER_SIZE
          @border_spacing = DEFAULT_BORDER_SPACING
          @border_type    = DEFAULT_BORDER_TYPE
          
          super options, &block
        end
        
        
        #-------------------------------------------------------------
        # Class Methods
        #-------------------------------------------------------------
        
        def self.formatted_type(type)
          case type.to_s.to_sym
          when :horizontal  then 'insideH'
          when :vertical    then 'insideV'
          when :top         then 'top'
          when :bottom      then 'bottom'
          when :left        then 'left'
          when :right       then 'right'
          else nil
          end
        end
        
        
        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
        
        #=============== GETTERS ==============================
        
        def formatted_type
          self.class.formatted_type(border_type)
        end
        
        def total_size
          border_size + (2 * border_spacing)
        end
        
        
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
        [:line, :type].each do |m|
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
          [:color, :line, :size, :spacing, :type]
        end
        
      end
      
    end
  end
end
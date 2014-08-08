require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models
      
      # This class handles block options passed to the page margins
      # method.
      #
      class RuleModel < BaseModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # constants
        const_set(:DEFAULT_RULE_COLOR,    'auto')
        const_set(:DEFAULT_RULE_SIZE,     4)        # 0.5pt in 1/8 points
        const_set(:DEFAULT_RULE_SPACING,  1)        # 0.125pt in 1/8 points
        const_set(:DEFAULT_RULE_LINE,     :single) 
        
        # accessors
        attr_reader :rule_color
        attr_reader :rule_size
        attr_reader :rule_spacing
        attr_reader :rule_line
        
        
        # initialization
        def initialize(**options, &block)
          super options, &block
          
          @rule_color   ||= DEFAULT_RULE_COLOR
          @rule_size    ||= DEFAULT_RULE_SIZE
          @rule_spacing ||= DEFAULT_RULE_SPACING
          @rule_line    ||= DEFAULT_RULE_LINE
        end
        
        
        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
        
        #=============== SETTERS ==============================
        
        # integers
        [:size, :spacing].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@rule_#{ m }", value.to_i)
          end
        end
        
        # strings
        [:color].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@rule_#{ m }", value.to_s)
          end
        end
        
        # symbols
        [:line].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@rule_#{ m }", value.to_s.to_sym)
          end
        end
        
        
        #=============== VALIDATION ==============================
        
        def valid?
          dims = [rule_size, rule_spacing]
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
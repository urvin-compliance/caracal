module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed to store and manipulate
      # list style data.
      #
      class ListStyleModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # constants
        const_set(:TYPE_MAP,              { ordered: 1, unordered: 2 })
        const_set(:DEFAULT_STYLE_LEFT,    720)      # units in twips 
        const_set(:DEFAULT_STYLE_LINE,    360)      # units in twips 
        const_set(:DEFAULT_STYLE_ALIGN,   :left)
        const_set(:DEFAULT_STYLE_START,   1)
        
        # accessors
        attr_reader :style_type
        attr_reader :style_level
        attr_reader :style_format
        attr_reader :style_value
        attr_reader :style_start
        attr_reader :style_align
        attr_reader :style_left
        attr_reader :style_line
        
        
        # initialization
        def initialize(options = {}, &block)
          options.each do |(key, value)|
            send(key, value)
          end
          
          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          end
          
          @style_align ||= DEFAULT_STYLE_ALIGN
          @style_left  ||= DEFAULT_STYLE_LEFT
          @style_line  ||= DEFAULT_STYLE_LINE
          @style_start ||= DEFAULT_STYLE_START
        end
        
        
        #-------------------------------------------------------------
        # Public Class Methods
        #-------------------------------------------------------------
        
        def self.formatted_type(type)
          TYPE_MAP.fetch(type)
        end
        
        
        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------
    
        #=============== SETTERS ==============================
        
        # integers
        [:level, :left, :line, :start].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@style_#{ m }", value.to_i)
          end
        end
        
        # strings
        [:format, :value].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@style_#{ m }", value.to_s)
          end
        end
        
        # symbols
        [:type, :align].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@style_#{ m }", value.to_s.to_sym)
          end
        end
        
        
        #=============== STATE ================================
        
        def matches?(type, level)
          style_type == type.to_s.to_sym && style_level == level.to_i
        end
        
        
        #=============== VALIDATION ===========================
        
        def valid?
          a = [:type, :level, :format, :value]
          a.map { |m| send("style_#{ m }") }.compact.size == a.size
        end
        
      end
      
    end
  end
end
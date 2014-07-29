module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed to store and manipulate
      # style data.
      #
      class StyleModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # constants
        const_set(:DEFAULT_STYLE_DEFAULT,   false)
        const_set(:DEFAULT_STYLE_TYPE,      :paragraph)
        const_set(:DEFAULT_STYLE_COLOR,     '333333')
        const_set(:DEFAULT_STYLE_SIZE,      20)
        const_set(:DEFAULT_STYLE_BOLD,      false)
        const_set(:DEFAULT_STYLE_ITALIC,    false)
        const_set(:DEFAULT_STYLE_UNDERLINE, false)
        const_set(:DEFAULT_STYLE_SPACING,   360)        # 0.25in in twips
        const_set(:DEFAULT_STYLE_JUSTIFY,   :left)
        const_set(:DEFAULT_STYLE_BASE,      'Normal')
        const_set(:DEFAULT_STYLE_NEXT,      'Normal')
        
        # accessors
        attr_reader :style_default
        attr_reader :style_type
        attr_reader :style_id
        attr_reader :style_name
        attr_reader :style_color
        attr_reader :style_font
        attr_reader :style_size
        attr_reader :style_bold
        attr_reader :style_italic
        attr_reader :style_underline
        attr_reader :style_justify
        attr_reader :style_spacing
        attr_reader :style_base
        attr_reader :style_next
    
        
        # initialization
        def initialize(options = {}, &block)
          options.each do |(key, value)|
            send(key, value)
          end
          
          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          end
          
          @style_default   ||= DEFAULT_STYLE_DEFAULT
          @style_type      ||= DEFAULT_STYLE_TYPE
          @style_color     ||= DEFAULT_STYLE_COLOR
          @style_size      ||= DEFAULT_STYLE_SIZE
          @style_bold      ||= DEFAULT_STYLE_BOLD
          @style_italic    ||= DEFAULT_STYLE_ITALIC
          @style_underline ||= DEFAULT_STYLE_UNDERLINE
          @style_spacing   ||= DEFAULT_STYLE_SPACING
          @style_justify   ||= DEFAULT_STYLE_JUSTIFY
          @style_base      ||= DEFAULT_STYLE_BASE
          @style_next      ||= DEFAULT_STYLE_NEXT
        end
        
        
        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------
    
        #=============== SETTERS ==============================
        
        # booleans
        [:default, :bold, :italic, :underline].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@style_#{ m }", !!value)
          end
        end
        
        # integers
        [:size, :spacing].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@style_#{ m }", value.to_i)
          end
        end
        
        # strings
        [:id, :name, :color, :font, :base, :next].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@style_#{ m }", value.to_s)
          end
        end
        
        # symbols
        [:type, :justify].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@style_#{ m }", value.to_s.to_sym)
          end
        end
        
        
        #=============== STATE ================================
        
        def matches?(str)
          style_id.downcase == str.to_s.downcase
        end
        
        
        #=============== VALIDATION ===========================
        
        def valid?
          (!style_id.nil? && !style_type.nil?)
        end
        
      end
      
    end
  end
end
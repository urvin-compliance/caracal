require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # paragraph style data.
      #
      class StyleModel < BaseModel

        #--------------------------------------------------
        # Configuration
        #--------------------------------------------------

        # constants
        const_set(:DEFAULT_STYLE_TYPE,       'paragraph')
        const_set(:DEFAULT_STYLE_COLOR,      '333333')
        const_set(:DEFAULT_STYLE_SIZE,       20)
        const_set(:DEFAULT_STYLE_BOLD,       false)
        const_set(:DEFAULT_STYLE_ITALIC,     false)
        const_set(:DEFAULT_STYLE_UNDERLINE,  false)
        const_set(:DEFAULT_STYLE_CAPS,       false)
        const_set(:DEFAULT_STYLE_ALIGN,      :left)
        const_set(:DEFAULT_STYLE_LINE,       360)        # 0.25in in twips
        const_set(:DEFAULT_STYLE_TOP,        0)          # 0.0in  in twips
        const_set(:DEFAULT_STYLE_BOTTOM,     0)          # 0.0in  in twips
        const_set(:DEFAULT_STYLE_BASE,       'Normal')
        const_set(:DEFAULT_STYLE_NEXT,       'Normal')

        # accessors
        attr_reader :style_default
        attr_reader :style_id
        attr_reader :style_type
        attr_reader :style_name
        attr_reader :style_color
        attr_reader :style_font
        attr_reader :style_size
        attr_reader :style_bold
        attr_reader :style_italic
        attr_reader :style_underline
        attr_reader :style_caps
        attr_reader :style_align
        attr_reader :style_top
        attr_reader :style_bottom
        attr_reader :style_line
        attr_reader :style_base
        attr_reader :style_next
        attr_reader :style_indent_left
        attr_reader :style_indent_right
        attr_reader :style_indent_first

        # initialization
        def initialize(options={}, &block)
          @style_default = false
          @style_type    = DEFAULT_STYLE_TYPE
          @style_base    = DEFAULT_STYLE_BASE
          @style_next    = DEFAULT_STYLE_NEXT

          super options, &block

          if (style_id == DEFAULT_STYLE_BASE)
            @style_default    ||= true
            @style_color      ||= DEFAULT_STYLE_COLOR
            @style_size       ||= DEFAULT_STYLE_SIZE
            @style_bold       ||= DEFAULT_STYLE_BOLD
            @style_italic     ||= DEFAULT_STYLE_ITALIC
            @style_underline  ||= DEFAULT_STYLE_UNDERLINE
            @style_caps       ||= DEFAULT_STYLE_CAPS
            @style_align      ||= DEFAULT_STYLE_ALIGN
            @style_top        ||= DEFAULT_STYLE_TOP
            @style_bottom     ||= DEFAULT_STYLE_BOTTOM
            @style_line       ||= DEFAULT_STYLE_LINE
          end
        end


        #--------------------------------------------------
        # Public Methods
        #--------------------------------------------------

        #========== SETTERS ===============================

        # booleans
        [:bold, :italic, :underline, :caps].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@style_#{ m }", !!value)
          end
        end

        # integers
        [:bottom, :size, :line, :top, :indent_left, :indent_right, :indent_first].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@style_#{ m }", value.to_i)
          end
        end

        # strings
        [:id, :type, :name, :color, :font].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@style_#{ m }", value.to_s)
          end
        end

        # symbols
        [:align].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@style_#{ m }", value.to_s.to_sym)
          end
        end

        # custom
        def type(value)
          allowed     = ['character', 'paragraph']
          given       = value.to_s.downcase.strip
          @style_type = allowed.include?(given) ? given : DEFAULT_STYLE_TYPE
        end


        #========== STATE =================================

        def matches?(str)
          style_id.downcase == str.to_s.downcase
        end


        #========== VALIDATION ============================

        def valid?
          a = [:id, :name, :type]
          a.map { |m| send("style_#{ m }") }.compact.size == a.size
        end


        #--------------------------------------------------
        # Private Methods
        #--------------------------------------------------
        private

        def option_keys
          [ :type,
            :bold,
            :italic,
            :underline,
            :caps,
            :top,
            :bottom,
            :size,
            :line,
            :id,
            :name,
            :color,
            :font,
            :align,
            :indent_left,
            :indent_right,
            :indent_first ]
        end

      end

    end
  end
end

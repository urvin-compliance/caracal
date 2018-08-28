require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # text data.
      #
      class TextModel < BaseModel

        #--------------------------------------------------
        # Configuration
        #--------------------------------------------------

        # accessors
        attr_reader :text_content
        attr_reader :text_style
        attr_reader :text_font
        attr_reader :text_color
        attr_reader :text_size
        attr_reader :text_bold
        attr_reader :text_italic
        attr_reader :text_underline
        attr_reader :text_bgcolor
        attr_reader :text_highlight_color
        attr_reader :text_vertical_align



        #--------------------------------------------------
        # Public Methods
        #--------------------------------------------------

        #========== GETTERS ===============================

        # .run_attributes
        def run_attributes
          {
            style:            text_style,
            font:             text_font,
            color:            text_color,
            size:             text_size,
            bold:             text_bold,
            italic:           text_italic,
            underline:        text_underline,
            bgcolor:          text_bgcolor,
            highlight_color:  text_highlight_color,
            vertical_align:   text_vertical_align
          }
        end


        #========== SETTERS ===============================

        # booleans
        [:bold, :italic, :underline].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@text_#{ m }", !!value)
          end
        end

        # integers
        [:size].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@text_#{ m }", value.to_i)
          end
        end

        # strings
        [:bgcolor, :color, :content, :font, :highlight_color, :style].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@text_#{ m }", value.to_s)
          end
        end

        # symbols
        [:vertical_align].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@text_#{ m }", value.to_s.to_sym)
          end
        end


        #========== VALIDATION ============================

        def valid?
          a = [:content]
          a.map { |m| send("text_#{ m }") }.compact.size == a.size
        end


        #--------------------------------------------------
        # Private Methods
        #--------------------------------------------------
        private

        def option_keys
          [:content, :style, :font, :color, :size, :bold, :italic, :underline, :bgcolor, :highlight_color, :vertical_align]
        end

        def method_missing(method, *args, &block)
          # I'm on the fence with respect to this implementation. We're ignoring
          # :method_missing errors to allow syntax flexibility for paragraph-type
          # models.  The issue is the syntax format of those models--the way we pass
          # the content value as a special argument--coupled with the model's
          # ability to accept nested instructions.
          #
          # By ignoring method missing errors here, we can pass the entire paragraph
          # block in the initial, built-in call to :text.
        end

      end

    end
  end
end

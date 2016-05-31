require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # text data.
      #
      class TextModel < BaseModel

        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------

        # accessors
        attr_reader :text_content
        attr_reader :text_font
        attr_reader :text_color
        attr_reader :text_size
        attr_reader :text_bold
        attr_reader :text_italic
        attr_reader :text_underline
        attr_reader :text_bgcolor
        attr_reader :text_vertical_align



        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------

        #=============== GETTERS ==============================

        # .run_attributes
        def run_attributes
          {
            font:           text_font,
            color:          text_color,
            size:           text_size,
            bold:           text_bold,
            italic:         text_italic,
            underline:      text_underline,
            bgcolor:        text_bgcolor,
            vertical_align: text_vertical_align
          }
        end


        #=============== SETTERS ==============================

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
        [:bgcolor, :color, :content, :font].each do |m|
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


        #=============== VALIDATION ===========================

        def valid?
          a = [:content]
          a.map { |m| send("text_#{ m }") }.compact.size == a.size
        end


        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private

        def option_keys
          [:content, :font, :color, :size, :bold, :italic, :underline, :bgcolor, :vertical_align]
        end

      end

    end
  end
end

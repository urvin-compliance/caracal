require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # text data.
      #
      class FieldModel < BaseModel

        #--------------------------------------------------
        # Configuration
        #--------------------------------------------------

        # constants
        const_set(:TYPE_MAP, { page: 'PAGE', numpages: 'NUMPAGES' })

        # accessors
        attr_reader :field_dirty
        attr_reader :field_type
        attr_reader :field_style
        attr_reader :field_font
        attr_reader :field_color
        attr_reader :field_size
        attr_reader :field_bold
        attr_reader :field_italic
        attr_reader :field_underline
        attr_reader :field_bgcolor
        attr_reader :field_highlight_color
        attr_reader :field_vertical_align

        #-------------------------------------------------------------
        # Public Class Methods
        #-------------------------------------------------------------

        def self.formatted_type(type)
          TYPE_MAP.fetch(type.to_s.to_sym)
        end


        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------

        #=============== GETTERS ==============================

        def formatted_type
          self.class.formatted_type(field_type)
        end

        #========== GETTERS ===============================

        # .run_attributes
        def run_attributes
          {
            style:            field_style,
            font:             field_font,
            color:            field_color,
            size:             field_size,
            bold:             field_bold,
            italic:           field_italic,
            underline:        field_underline,
            bgcolor:          field_bgcolor,
            highlight_color:  field_highlight_color,
            vertical_align:   field_vertical_align
          }
        end


        #========== SETTERS ===============================

        # booleans
        [:bold, :italic, :underline].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@field_#{ m }", !!value)
          end
        end

        # integers
        [:size].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@field_#{ m }", value.to_i)
          end
        end

        # strings
        [:bgcolor, :color, :dirty, :font, :highlight_color, :style, :type,].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@field_#{ m }", value.to_s)
          end
        end

        # symbols
        [:vertical_align].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@field_#{ m }", value.to_s.to_sym)
          end
        end


        #========== VALIDATION ============================

        def valid?
          a = [:type]
          a.map { |m| send("field_#{ m }") }.compact.size == a.size
        end


        #--------------------------------------------------
        # Private Methods
        #--------------------------------------------------
        private

        def option_keys
          [:type, :style, :font, :color, :size, :bold, :italic, :underline, :bgcolor, :highlight_color, :vertical_align]
        end

        def method_missing(method, *args, &block)
          # TODO: Better field centric description

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

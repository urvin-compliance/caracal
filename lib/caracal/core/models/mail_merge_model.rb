require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # text data.
      #
      class MailMergeModel < BaseModel

        #--------------------------------------------------
        # Configuration
        #--------------------------------------------------

        # accessors
        attr_reader :mail_merge_content
        attr_reader :mail_merge_style
        attr_reader :mail_merge_font
        attr_reader :mail_merge_color
        attr_reader :mail_merge_size
        attr_reader :mail_merge_bold
        attr_reader :mail_merge_italic
        attr_reader :mail_merge_underline
        attr_reader :mail_merge_bgcolor
        attr_reader :mail_merge_highlight_color
        attr_reader :mail_merge_vertical_align



        #--------------------------------------------------
        # Public Methods
        #--------------------------------------------------

        #========== GETTERS ===============================

        # .run_attributes
        def run_attributes
          {
            style:            mail_merge_style,
            font:             mail_merge_font,
            color:            mail_merge_color,
            size:             mail_merge_size,
            bold:             mail_merge_bold,
            italic:           mail_merge_italic,
            underline:        mail_merge_underline,
            bgcolor:          mail_merge_bgcolor,
            highlight_color:  mail_merge_highlight_color,
            vertical_align:   mail_merge_vertical_align,
            no_proof:         true
          }
        end


        #========== SETTERS ===============================

        # booleans
        [:bold, :italic, :underline].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@mail_merge_#{ m }", !!value)
          end
        end

        # integers
        [:size].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@mail_merge_#{ m }", value.to_i)
          end
        end

        # strings
        [:bgcolor, :color, :content, :font, :highlight_color, :style].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@mail_merge_#{ m }", value.to_s)
          end
        end

        # symbols
        [:vertical_align].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@mail_merge_#{ m }", value.to_s.to_sym)
          end
        end


        #========== VALIDATION ============================

        def valid?
          a = [:content]
          a.map { |m| send("mail_merge_#{ m }") }.compact.size == a.size
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

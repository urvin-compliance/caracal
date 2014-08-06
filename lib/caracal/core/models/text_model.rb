module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed to store and manipulate
      # text data.
      #
      class TextModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # accessors
        attr_reader :text_content
        attr_reader :text_style
        attr_reader :text_color
        attr_reader :text_size
        attr_reader :text_bold
        attr_reader :text_italic
        attr_reader :text_underline
    
        
        # initialization
        def initialize(**options, &block)
          options.each do |(key, value)|
            send(key, value)
          end
          
          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          end
        end
        
        
        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------
        
        #=============== GETTERS ==============================
        
        # .run_attributes
        def run_attributes
          {
            style:      text_style,
            color:      text_color,
            size:       text_size,
            bold:       text_bold,
            italic:     text_italic,
            underline:  text_underline,
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
        [:color, :content, :style].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@text_#{ m }", value.to_s)
          end
        end
        
        
        #=============== VALIDATION ===========================
        
        def valid?
          a = [:content]
          a.map { |m| send("text_#{ m }") }.compact.size == a.size
        end
        
      end
      
    end
  end
end
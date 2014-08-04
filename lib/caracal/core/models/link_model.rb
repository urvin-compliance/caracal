module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed to store and manipulate
      # text data.
      #
      class LinkModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # accessors
        attr_reader :link_content
        attr_reader :link_href
        attr_reader :link_style
        attr_reader :link_color
        attr_reader :link_size
        attr_reader :link_bold
        attr_reader :link_italic
        attr_reader :link_underline
    
        
        # initialization
        def initialize(options = {}, &block)
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
            style:      link_style,
            color:      link_color,
            size:       link_size,
            bold:       link_bold,
            italic:     link_italic,
            underline:  link_underline,
          }
        end
        
        
        #=============== SETTERS ==============================
        
        # booleans
        [:bold, :italic, :underline].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@link_#{ m }", !!value)
          end
        end
        
        # integers
        [:size].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@link_#{ m }", value.to_i)
          end
        end
        
        # strings
        [:color, :content, :href, :style].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@link_#{ m }", value.to_s)
          end
        end
        
        
        #=============== VALIDATION ===========================
        
        def valid?
          a = [:content, :href]
          a.map { |m| send("link_#{ m }") }.compact.size == a.size
        end
        
      end
      
    end
  end
end
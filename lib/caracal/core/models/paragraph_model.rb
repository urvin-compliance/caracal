module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed to store and manipulate
      # paragraph data.
      #
      class ParagraphModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # readers
        attr_reader :paragraph_style
        attr_reader :paragraph_color
        attr_reader :paragraph_size
        attr_reader :paragraph_bold
        attr_reader :paragraph_italic
        attr_reader :paragraph_underline
        
        # initialization
        def initialize(**options, &block)
          if content = options.delete(:content)
            text content
          end
          
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
        
        # .runs
        def runs
          @runs ||= []
        end
        
        # .run_attributes
        def run_attributes
          {
            color:      paragraph_color,
            size:       paragraph_size,
            bold:       paragraph_bold,
            italic:     paragraph_italic,
            underline:  paragraph_underline,
          }
        end
        
        
        #=============== SETTERS ==============================
        
        # booleans
        [:bold, :italic, :underline].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@paragraph_#{ m }", !!value)
          end
        end
        
        # integers
        [:size].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@paragraph_#{ m }", value.to_i)
          end
        end
        
        # strings
        [:color, :style].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@paragraph_#{ m }", value.to_s)
          end
        end
        
        # .link
        def link(content, href, options={}, &block)
          options.merge!({ content: content, href: href })
          
          model = Caracal::Core::Models::LinkModel.new(options, &block)
          if model.valid?
            runs << model
          else
            raise Caracal::Errors::InvalidLinkError, ':link method must receive strings for the display text and the external href.'
          end
        end
        
        # .text
        def text(content, options={}, &block)
          options.merge!({ content: content })
          
          model = Caracal::Core::Models::TextModel.new(options, &block)
          if model.valid?
            runs << model
          else
            raise Caracal::Errors::InvalidTextError, ':text method must receive a string for the display text.'
          end
        end
        
        
        #=============== VALIDATION ===========================
        
        def valid?
          runs.size > 0
        end
        
      end
      
    end
  end
end
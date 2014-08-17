require 'caracal/core/models/base_model'
require 'caracal/core/models/link_model'
require 'caracal/core/models/text_model'
require 'caracal/errors'


module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed to store and manipulate
      # paragraph data.
      #
      class ParagraphModel < BaseModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # readers
        attr_reader :paragraph_style
        attr_reader :paragraph_align
        attr_reader :paragraph_color
        attr_reader :paragraph_size
        attr_reader :paragraph_bold
        attr_reader :paragraph_italic
        attr_reader :paragraph_underline
        
        # initialization
        def initialize(options = {}, &block)
          if content = options.delete(:content)
            text content, options.dup
          end
          
          super options, &block
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
        
        # symbols
        [:align].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@paragraph_#{ m }", value.to_s.to_sym)
          end
        end
        
        
        #=============== SUB-METHODS ===========================
        
        # .link
        def link(content = nil, href = nil, options = {}, &block)
          options.merge!({ content: content }) if content
          options.merge!({ href:    href    }) if href
          
          model = Caracal::Core::Models::LinkModel.new(options, &block)
          if model.valid?
            runs << model
          else
            raise Caracal::Errors::InvalidModelError, ':link method must receive strings for the display text and the external href.'
          end
        end
        
        # .text
        def text(content = nil, options = {}, &block)
          options.merge!({ content: content }) if content
          
          model = Caracal::Core::Models::TextModel.new(options, &block)
          if model.valid?
            runs << model
          else
            raise Caracal::Errors::InvalidModelError, ':text method must receive a string for the display text.'
          end
        end
        
        
        #=============== VALIDATION ===========================
        
        def valid?
          runs.size > 0
        end
        
        
        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private
        
        def option_keys
          [:content, :style, :align, :color, :size, :bold, :italic, :underline]
        end
        
      end
      
    end
  end
end
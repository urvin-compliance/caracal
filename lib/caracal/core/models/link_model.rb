require 'caracal/core/models/text_model'


module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed to store and manipulate
      # link data.
      #
      class LinkModel < TextModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # constants
        const_set(:DEFAULT_LINK_COLOR,      '1155cc')
        const_set(:DEFAULT_LINK_UNDERLINE,  true) 
        
        # readers (create aliases for superclass methods to conform 
        # to expected naming convention.)
        attr_reader  :link_href
        alias_method :link_content,   :text_content
        alias_method :link_style,     :text_style
        alias_method :link_color,     :text_color
        alias_method :link_size,      :text_size
        alias_method :link_bold,      :text_bold
        alias_method :link_italic,    :text_italic
        alias_method :link_underline, :text_underline
        
        # initialization
        def initialize(options = {}, &block)
          @text_color     = DEFAULT_LINK_COLOR
          @text_underline = DEFAULT_LINK_UNDERLINE
          
          super options, &block
        end
        
        
        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------
    
        #=============== SETTERS ==============================
        
        # strings
        [:href].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@link_#{ m }", value.to_s)
          end
        end
        
        
        #=============== VALIDATION ===========================
        
        def valid?
          a = [:content, :href]
          a.map { |m| send("link_#{ m }") }.compact.size == a.size
        end
        
        
        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private
        
        def option_keys
          (super + [:href]).flatten
        end
        
      end
      
    end
  end
end
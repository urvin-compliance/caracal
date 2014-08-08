require 'caracal/core/models/list_model'
require 'caracal/core/models/paragraph_model'
require 'caracal/errors'


module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed to store and manipulate
      # list item data.
      #
      class ListItemModel < ParagraphModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # accessors
        attr_accessor :nested_list
        
        # readers (create aliases for superclass methods to conform 
        # to expected naming convention.)
        attr_reader  :list_item_type
        attr_reader  :list_item_level
        alias_method :list_item_style,     :paragraph_style
        alias_method :list_item_color,     :paragraph_color
        alias_method :list_item_size,      :paragraph_size
        alias_method :list_item_bold,      :paragraph_bold
        alias_method :list_item_italic,    :paragraph_italic
        alias_method :list_item_underline, :paragraph_underline
        
        
        
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
        
        # integers
        [:level].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@list_item_#{ m }", value.to_i)
          end
        end

        # symbols
        [:type].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@list_item_#{ m }", value.to_s.to_sym)
          end
        end
        
        
        #=============== SUB-METHODS ===========================
        
        # .ol
        def ol(**options, &block)
          options.merge!({ type: :ordered, level: list_item_level + 1 })
          
          model = Caracal::Core::Models::ListModel.new(options, &block)
          if model.valid?
            @nested_list = model
          else
            raise Caracal::Errors::InvalidModelError, 'Ordered lists require at least one list item.'
          end
        end
        
        # .ul
        def ul(**options, &block)
          options.merge!({ type: :unordered, level: list_item_level + 1 })
          
          model = Caracal::Core::Models::ListModel.new(options, &block)
          if model.valid?
            @nested_list = model
          else
            raise Caracal::Errors::InvalidModelError, 'Unordered lists require at least one list item.'
          end
        end
        
        
        #=============== VALIDATION ===========================
        
        def valid?
          a = [:type, :level]
          required = a.map { |m| send("list_item_#{ m }") }.compact.size == a.size
          required && !runs.empty?
        end
        
      end
      
    end
  end
end
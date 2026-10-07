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
        attr_writer :continuation

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
        alias_method :list_item_bgcolor,   :paragraph_bgcolor



        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------

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


        #=============== NESTED LISTS =========================

        # This method returns the nested lists in the order they were
        # added, each with the number of runs that came before it, so text
        # after a nested list can be rendered after it.
        #
        def nested_lists
          @nested_lists ||= []
        end

        def nested_list
          (pair = nested_lists.last) && pair.last
        end

        def nested_list=(model)
          nested_lists << [runs.size, model]
        end

        # This method returns whether this is the text that follows a
        # nested list, which renders as an unnumbered paragraph indented
        # with the item.
        #
        def continuation?
          !!@continuation
        end

        # This method returns this item and everything nested in it in
        # document order: the item's text up to its first nested list, the
        # nested list's items, then any text that follows, and so on.
        #
        def recursive_items
          return [self] if nested_lists.empty?

          items = []
          start = 0
          nested_lists.each do |(index, list)|
            items << segment(start...index, items.any?) if items.empty? || index > start
            items.concat(list.recursive_items)
            start = index
          end
          items << segment(start...runs.size, true) if runs.size > start
          items
        end


        #=============== SUB-METHODS ===========================

        # .ol
        def ol(options={}, &block)
          options.merge!({ type: :ordered, level: list_item_level + 1 })

          model = Caracal::Core::Models::ListModel.new(options, &block)
          if model.valid?
            self.nested_list = model
          else
            raise Caracal::Errors::InvalidModelError, 'Ordered lists require at least one list item.'
          end
          model
        end

        # .ul
        def ul(options={}, &block)
          options.merge!({ type: :unordered, level: list_item_level + 1 })

          model = Caracal::Core::Models::ListModel.new(options, &block)
          if model.valid?
            self.nested_list = model
          else
            raise Caracal::Errors::InvalidModelError, 'Unordered lists require at least one list item.'
          end
          model
        end


        #=============== VALIDATION ===========================

        def valid?
          a = [:type, :level]
          required = a.map { |m| send("list_item_#{ m }") }.compact.size == a.size
          required && !runs.empty?
        end


        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private

        # This method returns a copy of the item holding only the given runs.
        def segment(range, continuation)
          copy = dup
          copy.instance_variable_set(:@runs, runs[range])
          copy.instance_variable_set(:@nested_lists, [])
          copy.continuation = continuation
          copy
        end

        def option_keys
          [:type, :level, :content, :style, :color, :size, :bold, :italic, :underline, :bgcolor]
        end

      end

    end
  end
end

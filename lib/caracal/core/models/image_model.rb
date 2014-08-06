module Caracal
  module Core
    module Models
      
      # This class handles block options passed to the img method.
      #
      class ImageModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # constants
        const_set(:DEFAULT_IMAGE_WIDTH,   0)        # units in pixels. (will cause error)
        const_set(:DEFAULT_IMAGE_HEIGHT,  0)        # units in pixels. (will cause error)
        const_set(:DEFAULT_IMAGE_ALIGN,   :left) 
        const_set(:DEFAULT_IMAGE_TOP,     8)        # units in pixels. 
        const_set(:DEFAULT_IMAGE_BOTTOM,  8)        # units in pixels. 
        const_set(:DEFAULT_IMAGE_LEFT,    8)        # units in pixels. 
        const_set(:DEFAULT_IMAGE_RIGHT,   8)        # units in pixels. 
        
        # accessors
        attr_reader :image_url
        attr_reader :image_width
        attr_reader :image_height
        attr_reader :image_align
        attr_reader :image_top
        attr_reader :image_bottom
        attr_reader :image_left
        attr_reader :image_right
        
        
        # initialization
        def initialize(options = {}, &block)
          options.each do |(key, value)|
            send(key, value)
          end
          
          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          end
          
          @image_width  ||= DEFAULT_IMAGE_WIDTH
          @image_height ||= DEFAULT_IMAGE_HEIGHT
          @image_align  ||= DEFAULT_IMAGE_ALIGN
          @image_top    ||= DEFAULT_IMAGE_TOP
          @image_bottom ||= DEFAULT_IMAGE_BOTTOM
          @image_left   ||= DEFAULT_IMAGE_LEFT
          @image_right  ||= DEFAULT_IMAGE_RIGHT
        end
        
        
        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
        
        #=============== GETTERS ==============================
        
        [:width, :height, :top, :bottom, :left, :right].each do |m|
          define_method "formatted_#{ m }" do
            value = send("image_#{ m }")
            pixels_to_emus(value)
          end
        end
        
        
        #=============== SETTERS ==============================
        
        # integers
        [:width, :height, :top, :bottom, :left, :right].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@image_#{ m }", value.to_i)
          end
        end
        
        # strings
        [:url].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@image_#{ m }", value.to_s)
          end
        end
        
        # symbols
        [:align].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@image_#{ m }", value.to_s.to_sym)
          end
        end
        
        
        #=============== VALIDATION ==============================
        
        def valid?
          dims = [:width, :height, :top, :bottom, :left, :right].map { |m| send("image_#{ m }") }
          dims.all? { |d| d > 0 }
        end
        
        
        
        #-------------------------------------------------------------
        # Private Methods
        #-------------------------------------------------------------
        private
      
        def pixels_to_emus(value)
          pixels        = value.to_i
          inches        = pixels / 72.0
          emus_per_inch = 914400
        
          emus = (inches * emus_per_inch).to_i 
        end
        
      end
      
    end
  end
end
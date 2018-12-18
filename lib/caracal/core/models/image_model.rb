require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models
      
      # This class handles block options passed to the img method.
      #
      class ImageModel < BaseModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # constants
        const_set(:DEFAULT_IMAGE_PPI,     72)       # pixels per inch
        const_set(:DEFAULT_IMAGE_WIDTH,   0)        # units in pixels. (will cause error)
        const_set(:DEFAULT_IMAGE_HEIGHT,  0)        # units in pixels. (will cause error)
        const_set(:DEFAULT_IMAGE_ALIGN,   :left) 
        const_set(:DEFAULT_IMAGE_TOP,     8)        # units in pixels. 
        const_set(:DEFAULT_IMAGE_BOTTOM,  8)        # units in pixels. 
        const_set(:DEFAULT_IMAGE_LEFT,    8)        # units in pixels. 
        const_set(:DEFAULT_IMAGE_RIGHT,   8)        # units in pixels. 
        
        # accessors
        attr_reader :image_url
        attr_reader :image_data
        attr_reader :image_ppi
        attr_reader :image_width
        attr_reader :image_height
        attr_reader :image_align
        attr_reader :image_top
        attr_reader :image_bottom
        attr_reader :image_left
        attr_reader :image_right
        
        
        # initialization
        def initialize(options={}, &block)
          @image_ppi    = DEFAULT_IMAGE_PPI
          @image_width  = DEFAULT_IMAGE_WIDTH
          @image_height = DEFAULT_IMAGE_HEIGHT
          @image_align  = DEFAULT_IMAGE_ALIGN
          @image_top    = DEFAULT_IMAGE_TOP
          @image_bottom = DEFAULT_IMAGE_BOTTOM
          @image_left   = DEFAULT_IMAGE_LEFT
          @image_right  = DEFAULT_IMAGE_RIGHT
          
          super options, &block
        end
        
        
        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
        
        #=============== GETTERS ==============================
        
        [:width, :height].each do |m|
          define_method "formatted_#{ m }" do
            value = send("image_#{ m }")
            pixels_to_emus(value, image_ppi)
          end
        end
        
        [:top, :bottom, :left, :right].each do |m|
          define_method "formatted_#{ m }" do
            value = send("image_#{ m }")
            pixels_to_emus(value, 72)
          end
        end
        
        def relationship_target
          image_url || image_data
        end
        
        
        #=============== SETTERS ==============================
        
        # integers
        [:ppi, :width, :height, :top, :bottom, :left, :right].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@image_#{ m }", value.to_i)
          end
        end
        
        # strings
        [:data, :url].each do |m|
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
          dims = [:ppi, :width, :height, :top, :bottom, :left, :right].map { |m| send("image_#{ m }") }
          dims.all? { |d| d > 0 }
        end
        
        
        
        #-------------------------------------------------------------
        # Private Methods
        #-------------------------------------------------------------
        private
        
        def option_keys
          [:url, :width, :height, :align, :top, :bottom, :left, :right]
        end
        
        def pixels_to_emus(value, ppi)
          pixels        = value.to_i
          inches        = pixels / ppi.to_f
          emus_per_inch = 914400
        
          emus = (inches * emus_per_inch).to_i 
        end
        
      end
      
    end
  end
end
require 'caracal/core/models/base_model'
require 'caracal/core/models/margin_model'


module Caracal
  module Core
    module Models
      
      # This class handles block options passed to tables via their data 
      # collections.
      #
      class TableCellModel < BaseModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # constants
        const_set(:DEFAULT_CELL_BACKGROUND,   'ffffff')
        const_set(:DEFAULT_CELL_MARGINS,      Caracal::Core::Models::MarginModel.new({ top: 200, bottom: 200, left: 200, right: 200 }))
        
        # accessors
        attr_reader :cell_background 
        attr_reader :cell_width
        attr_reader :cell_margins
        
        # initialization
        def initialize(**options, &block)
          if content = options.delete(:content)
            p content, options.dup
          end
          
          super options, &block
          
          @cell_background ||= DEFAULT_CELL_BACKGROUND
          @cell_margins    ||= DEFAULT_CELL_MARGINS
        end
        
        
        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
        
        #=============== DATA ACCESSORS =======================
        
        def contents
          @contents ||= []
        end
        
        
        #=============== GETTERS ==============================
        
        # margin attrs
        [:top, :bottom, :left, :right].each do |m|
          define_method "cell_margin_#{ m }" do
            cell_margins.send("margin_#{ m }")
          end
        end
        
        
        #=============== SETTERS ==============================
        
        # integers
        [:width].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@cell_#{ m }", value.to_i)
          end
        end
        
        # models
        [:margins].each do |m|
          define_method "#{ m }" do |**options, &block|
            instance_variable_set("@cell_#{ m }", Caracal::Core::Models::MarginModel.new(options, &block))
          end
        end
        
        # strings
        [:background].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@cell_#{ m }", value.to_s)
          end
        end
        
        
        #=============== VALIDATION ==============================
        
        def valid?
          contents.size > 0
        end
        
        
        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private
        
        def option_keys
          [:background, :margins, :width]
        end
        
      end
      
    end
  end
end
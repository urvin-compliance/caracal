require 'caracal/core/breaks'
require 'caracal/core/images'
require 'caracal/core/lists'
require 'caracal/core/rules'
# require 'caracal/core/tables'
require 'caracal/core/text'

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
        
        # mixins
        include Caracal::Core::Breaks
        include Caracal::Core::Images
        include Caracal::Core::Lists
        include Caracal::Core::Rules
        # include Caracal::Core::Tables
        include Caracal::Core::Text
        
        # constants
        const_set(:DEFAULT_CELL_BACKGROUND,   'ffffff')
        const_set(:DEFAULT_CELL_MARGINS,      Caracal::Core::Models::MarginModel.new)
        
        # accessors
        attr_reader :cell_background 
        attr_reader :cell_width
        attr_reader :cell_margins
        
        # initialization
        def initialize(**options, &block)
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
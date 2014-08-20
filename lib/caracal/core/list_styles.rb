# encoding: utf-8
require 'caracal/core/models/list_style_model'
require 'caracal/errors'


module Caracal
  module Core
    
    # This module encapsulates all the functionality related to defining
    # list styles.
    #
    module ListStyles
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Class Methods
          #-------------------------------------------------------------
          
          def self.default_list_styles
            [
              { type: :ordered,   level: 0, format: 'decimal',     value: '%1.', left: 720,  indent: 360  },
              { type: :ordered,   level: 1, format: 'lowerLetter', value: '%2.', left: 1440, indent: 1080 },
              { type: :ordered,   level: 2, format: 'lowerRoman',  value: '%3.', left: 2160, indent: 1800, align: :right },
              { type: :ordered,   level: 3, format: 'decimal',     value: '%4.', left: 2880, indent: 2520 },
              { type: :ordered,   level: 4, format: 'lowerLetter', value: '%5.', left: 3600, indent: 3240 },
              { type: :ordered,   level: 5, format: 'lowerRoman',  value: '%6.', left: 4320, indent: 3960, align: :right },
              { type: :ordered,   level: 6, format: 'decimal',     value: '%7.', left: 5040, indent: 4680 },
              { type: :ordered,   level: 7, format: 'lowerLetter', value: '%8.', left: 5760, indent: 5400 },
              { type: :ordered,   level: 8, format: 'lowerRoman',  value: '%9.', left: 6480, indent: 6120, align: :right },
                                                                                             
              { type: :unordered, level: 0, format: 'bullet',      value: '●',   left: 720,  indent: 360  },
              { type: :unordered, level: 1, format: 'bullet',      value: '○',   left: 1440, indent: 1080 },
              { type: :unordered, level: 2, format: 'bullet',      value: '■',   left: 2160, indent: 1800 },
              { type: :unordered, level: 3, format: 'bullet',      value: '●',   left: 2880, indent: 2520 },
              { type: :unordered, level: 4, format: 'bullet',      value: '○',   left: 3600, indent: 3240 },
              { type: :unordered, level: 5, format: 'bullet',      value: '■',   left: 4320, indent: 3960 },
              { type: :unordered, level: 6, format: 'bullet',      value: '●',   left: 5040, indent: 4680 },
              { type: :unordered, level: 7, format: 'bullet',      value: '○',   left: 5760, indent: 5400 },
              { type: :unordered, level: 8, format: 'bullet',      value: '■',   left: 6480, indent: 6120 }
            ]           
          end
          
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          #============== ATTRIBUTES ==========================
          
          def list_style(options={}, &block)
            model = Caracal::Core::Models::ListStyleModel.new(options, &block)
            
            if model.valid?
              register_list_style(model)
            else
              raise Caracal::Errors::InvalidModelError, 'list style must define a :type, :level, :format, and :value.'
            end
            model
          end
          
          
          #============== GETTERS =============================
          
          def list_styles
            @list_styles ||= []
          end
          
          def find_list_style(type, level)
            list_styles.find { |s| s.matches?(type, level) }
          end
          
          
          #============== REGISTRATION ========================
          
          def register_list_style(model)
            unregister_list_style(model.style_type, model.style_level)
            list_styles << model
            model
          end
          
          def unregister_list_style(type, level)
            if s = find_list_style(type, level)
              list_styles.delete(s)
            end
          end
          
        end
      end
    end
    
  end
end
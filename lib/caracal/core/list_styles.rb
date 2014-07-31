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
              
            ]           
          end
          
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          #============== ATTRIBUTES ==========================
          
          def list_style(options = {}, &block)
            model = Caracal::Core::Models::ListStyleModel.new(options, &block)
            
            if model.valid?
              register_list_style(model)
            else
              raise Caracal::Errors::InvalidStyleError, 'list style must define a :type, :level, :format, and :value.'
            end
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
            unless s = find_list_style(model.style_type, model.style_level)
              list_styles << model
            end
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
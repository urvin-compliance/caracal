module Caracal
  module Core
    
    # This module encapsulates all the functionality related to defining
    # paragraph styles.
    #
    module Styles
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Class Methods
          #-------------------------------------------------------------
          
          def self.default_styles
            [
              { id: 'Normal',   name: 'normal',    font: 'Arial',        size: 22, color: '000000' },
              { id: 'Heading1', name: 'heading 1', font: 'Trebuchet MS', size: 32 },
              { id: 'Heading2', name: 'heading 2', font: 'Trebuchet MS', size: 26, bold: true },
              { id: 'Heading3', name: 'heading 3', font: 'Trebuchet MS', size: 24, color: '666666', bold: true },
              { id: 'Heading4', name: 'heading 4', font: 'Trebuchet MS', size: 22, color: '666666', underline: true },
              { id: 'Heading5', name: 'heading 5', font: 'Trebuchet MS', size: 22, color: '666666' },
              { id: 'Heading6', name: 'heading 6', font: 'Trebuchet MS', size: 22, color: '666666', italic: true },
              { id: 'Title',    name: 'title',     font: 'Trebuchet MS', size: 42 },
              { id: 'Subtitle', name: 'subtitle',  font: 'Trebuchet MS', size: 26, color: '666666', italic: true }
            ]           
          end
          
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          #============== ATTRIBUTES ==========================
          
          def style(options = {}, &block)
            model = Caracal::Core::Models::StyleModel.new(options, &block)
            
            if model.valid?
              register_style(model)
            else
              raise Caracal::Errors::InvalidStyleError, 'style must define an :id and :name.'
            end
          end
          
          
          #============== GETTERS =============================
          
          def styles
            @styles ||= []
          end
          
          def find_style(id)
            styles.find { |s| s.matches?(id) }
          end
          
          
          #============== REGISTRATION ========================
          
          def register_style(model)
            unless s = find_style(model.style_id)
              styles << model
            end
          end
          
          def unregister_style(id)
            if s = find_style(id)
              styles.delete(s)
            end
          end
          
        end
      end
    end
    
  end
end
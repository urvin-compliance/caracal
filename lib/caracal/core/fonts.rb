module Caracal
  module Core
    
    # This module encapsulates all the functionality related to registering
    # fonts.
    #
    module Fonts
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Class Methods
          #-------------------------------------------------------------
          
          def self.default_fonts
            [
              { name: 'Arial' },
              { name: 'Droid Serif' }
            ]           
          end
          
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          #============== ATTRIBUTES ==========================
          
          def font(opts, &block)
            model = Caracal::Core::Models::FontModel.new(opts, &block)
            
            if model.valid?
              register_font(model)
            else
              raise Caracal::Errors::InvalidFontError, 'font must specify the :name attribute.'
            end
          end
          
          
          #============== GETTERS =============================
          
          def fonts
            @fonts ||= []
          end
          
          def find_font(name)
            fonts.find { |f| f.matches?(name) }
          end
          
          
          #============== REGISTRATION ========================
          
          def register_font(model)
            unless f = find_font(model.font_name)
              fonts << model
            end
          end
          
          def unregister_font(name)
            if f = find_font(name)
              fonts.delete(f)
            end
          end
          
        end
      end
    end
    
  end
end
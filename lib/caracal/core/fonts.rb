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
          
          def font(name)
            register_font({ name: name.to_s })
          end
          
          
          #============== GETTERS =============================
          
          def fonts
            @fonts ||= []
          end
          
          def find_font(name)
            fonts.find { |f| f.matches?(name) }
          end
          
          
          #============== REGISTRATION ========================
          
          def register_font(opts = {})
            unless f = find_font(opts[:name])
              f = Caracal::Core::Models::FontModel.new(opts)
              fonts << f
            end
            f
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
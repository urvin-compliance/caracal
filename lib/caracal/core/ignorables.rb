module Caracal
  module Core

    # This module encapsulates all the functionality related to registering and
    # retrieving ignorable namespaces.
    #
    module Ignorables
      def self.included(base)
        base.class_eval do

          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          #============== ATTRIBUTES ==========================

          def ignorable(prefix)
            register_ignorable(prefix)
          end


          #============== GETTERS =============================

          def ignorables
            @ignorables ||= []
          end


          #============== REGISTRATION ========================

          def register_ignorable(prefix)
            unless ignorables.include?(prefix)
              ignorables << prefix
              prefix
            end
          end

          def unregister_ignorable(prefix)
            ignorables.delete(prefix)
          end

        end
      end
    end

  end
end

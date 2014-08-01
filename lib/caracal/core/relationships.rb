module Caracal
  module Core
    
    # This module encapsulates all the functionality related to registering and 
    # retrieving relationships.
    #
    module Relationships
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Class Methods
          #-------------------------------------------------------------
          
          def self.default_relationships
            [
              { target: 'fontTable.xml',  type: :font       },
              { target: 'footer1.xml',    type: :footer     },
              { target: 'numbering.xml',  type: :numbering  },
              { target: 'settings.xml',   type: :setting    },
              { target: 'styles.xml',     type: :style      }
            ]           
          end
          
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          #============== ATTRIBUTES ==========================
          
          def relationship(opts, &block)
            model = Caracal::Core::Models::RelationshipModel.new(opts, &block)
            
            if model.valid?
              register_relationship(model)
            else
              raise Caracal::Errors::InvalidFontError, 'relationship must specify the :target and :type attribute.'
            end
          end
          
          
          #============== GETTERS =============================
          
          def relationships
            @relationships ||= []
          end
                    
          def find_relationship(target)
            relationships.find { |r| r.matches?(target) }
          end
          
          
          #============== REGISTRATION ========================
          
          def register_relationship(model)
            unless r = find_relationship(model.relationship_target)
              model.register
              relationships << model
              r = model
            end
            r
          end
          
          def unregister_relationship(target)
            if r = find_relationship(target)
              r.unregister
              relationships.delete(r)
            end
          end
          
        end
      end
    end
    
  end
end
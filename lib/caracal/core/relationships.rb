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
          
          def relationships
            @relationships ||= []
          end
                    
          def relationship_for_target(target)
            relationships.find { |r| r.matches?(target.to_s) }
          end
          
          def register_relationship(target, type)
            r = relationship_for_target(target)
            if r.nil?
              r  = RelationshipModel.new(target, type)
              r.register
              @relationships << r
            end
            r
          end
          
          def unregister_relationship(target)
            r = relationship_for_target(target)
            unless r.nil?
              r.unregister
              @relationships.delete(r)
            end
          end
          
        end
      end
    end
    
  end
end
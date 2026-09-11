require 'caracal/core/models/relationship_model'
require 'caracal/errors'


module Caracal
  module Core
    
    # This module encapsulates all the functionality related to registering and 
    # retrieving relationships.
    #
    module Relationships
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Configuration
          #-------------------------------------------------------------
          
          attr_reader :relationship_counter
          
          
          #-------------------------------------------------------------
          # Class Methods
          #-------------------------------------------------------------
          
          def self.default_relationships
            [
              { target: 'fontTable.xml',  type: :font      },
              { target: 'footer1.xml',    type: :footer    },
              { target: 'header1.xml',    type: :header    },
              { target: 'numbering.xml',  type: :numbering },
              { target: 'settings.xml',   type: :setting   },
              { target: 'styles.xml',     type: :style     }
            ]           
          end
          
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          #============== ATTRIBUTES ==========================
          
          def relationship(options={}, &block)
            id = relationship_counter.to_i + 1
            options.merge!({ id: id })

            model = Caracal::Core::Models::RelationshipModel.new(options, &block)
            if model.valid?
              @relationship_counter = id
              rel = register_relationship(model)
            else
              raise Caracal::Errors::InvalidModelError, 'relationship must specify the :id, :target, and :type attributes.'
            end
            rel
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
              relationships << model
              r = model
            end
            r
          end
          
          def unregister_relationship(target)
            if r = find_relationship(target)
              relationships.delete(r)
            end
          end
          
        end
      end
    end
    
  end
end
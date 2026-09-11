require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed to store and manipulate
      # relationship data.
      #
      class RelationshipModel < BaseModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
    
        # constants
        TYPE_MAP = {
          font:       'http://schemas.openxmlformats.org/officeDocument/2006/relationships/fontTable', 
          footer:     'http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer',
          header:     'http://schemas.openxmlformats.org/officeDocument/2006/relationships/header',
          image:      'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image',
          link:       'http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink',
          numbering:  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/numbering',
          setting:    'http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings',
          style:      'http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles'
        }
        
        # accessors
        attr_reader :relationship_id
        attr_reader :relationship_key
        attr_reader :relationship_type
        attr_reader :relationship_target
        attr_reader :relationship_data
    
        
        
        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------
    
        #=================== GETTERS =============================
        
        def formatted_id
          "rId#{ relationship_id }"
        end
        
        def formatted_target
          if relationship_type == :image
            ext = relationship_target.to_s.split('.').last
            ext = ext.split('?').first
            "media/image#{ relationship_id }.#{ ext }"
          else
            relationship_target
          end
        end
        
        def formatted_type
          TYPE_MAP.fetch(relationship_type)
        end
        
        
        #=================== SETTERS =============================
        
        def id(value)
          @relationship_id = value.to_i
        end
        
        def type(value)
          @relationship_type = value.to_s.downcase.to_sym
        end
        
        def target(value)
          @relationship_target = value.to_s
          @relationship_key    = value.to_s.downcase
        end
        
        def data(value)
          @relationship_data = value.to_s
        end
        
        
        #=================== STATE ===============================
        
        def matches?(str)
          relationship_key.downcase == str.to_s.downcase
        end
        
        def target_mode?
          relationship_type == :link
        end
        
        
        #=============== VALIDATION ===========================
        
        def valid?
          required = [:id, :target, :type]
          required.all? { |m| !send("relationship_#{ m }").nil? }
        end
        
        
        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private
        
        def option_keys
          [:id, :type, :target, :data]
        end
        
      end
      
    end
  end
end
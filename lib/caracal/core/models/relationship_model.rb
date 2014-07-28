module Caracal
  module Core
    module Models
      
      # This class encapsulates the logic needed to store and manipulate
      # relationship data.
      #
      class RelationshipModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
    
        # class vars (not worried about inheritance)
        @@count = 0
        
        # constants
        TYPE_MAP = {
          font:       'http://schemas.openxmlformats.org/officeDocument/2006/relationships/fontTable', 
          footer:     'http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer',
          image:      'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image',
          link:       'http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink',
          numbering:  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/numbering',
          setting:    'http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings',
          style:      'http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles'
        }
        
        # accessors
        attr_accessor :id
        attr_accessor :type
        attr_accessor :target
        attr_accessor :key
        
        # initialization
        def initialize(target, type)
          @@count += 1
          
          @id      = @@count
          @type    = type.to_s.to_sym
          @target  = target.to_s
          @key     = target.to_s
        end
        
        
        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------
    
        def matches?(str)
          key == str.to_s
        end
        
        def register
          # add later with images
        end
        
        def unregister
          # add later with images
        end
        
        #=================== XML METHODS =============================
        
        def formatted_id
          "rId#{ id }"
        end
        
        def formatted_type
          TYPE_MAP.fetch(type)
        end
        
        def target_mode?
          type == :link
        end
        
      end
      
    end
  end
end
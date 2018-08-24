require 'caracal/core/models/bookmark_model'
require 'caracal/errors'


module Caracal
  module Core
    
    # This module encapsulates all the functionality related to adding 
    # bookmarks to the document.
    #
    module Bookmarks
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          #============== BOOKMARKS ==========================
          
          def bookmark_start(*args, &block)
            bookmark(true, 'Bookmark starting tags require an id and a name.', *args, &block)
          end

          def bookmark_end(*args, &block)
            bookmark(false, 'Bookmark ending tags require an id.', *args, &block)
          end

        private

          def bookmark(start, message, *args, &block)
            options = Caracal::Utilities.extract_options!(args)
            options.merge!({ start: start})
            
            model = Caracal::Core::Models::BookmarkModel.new(options, &block)
            if model.valid?
              contents << model
            else
              raise Caracal::Errors::InvalidModelError, message
            end
            model
          end
        end
      end
    end
    
  end
end

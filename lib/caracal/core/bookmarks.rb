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

          #------------------------------------------------
          # Public Methods
          #------------------------------------------------

          #========== BOOKMARKS ===========================

          def bookmark_start(*args, &block)
            options = Caracal::Utilities.extract_options!(args)
            options.merge!({ start: true})

            model = Caracal::Core::Models::BookmarkModel.new(options, &block)
            if model.valid?
              contents << model
            else
              raise Caracal::Errors::InvalidModelError, 'Bookmark starting tags require an id and a name.'
            end
            model
          end

          def bookmark_end(*args, &block)
            options = Caracal::Utilities.extract_options!(args)
            options.merge!({ start: false})

            model = Caracal::Core::Models::BookmarkModel.new(options, &block)
            if model.valid?
              contents << model
            else
              raise Caracal::Errors::InvalidModelError, 'Bookmark ending tags require an id.'
            end
            model
          end
          
        end
      end
    end

  end
end

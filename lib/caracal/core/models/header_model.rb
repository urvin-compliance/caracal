require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class holds the contents of the header that appears on
      # every page of the document.
      #
      class HeaderModel < BaseModel

        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------

        #=============== DATA ACCESSORS =======================

        def contents
          @contents ||= []
        end

        # Images and links in the header are registered with the document,
        # which numbers them and writes the media, but Word resolves them
        # against the header part's own relationships. The renderer collects
        # them here so they can be written to that part.
        #
        def relationships
          @relationships ||= []
        end


        #=============== VALIDATION ===========================

        def valid?
          contents.size > 0
        end

      end

    end
  end
end

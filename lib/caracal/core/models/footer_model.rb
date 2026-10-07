require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class holds the contents of the footer that appears on
      # every page of the document.
      #
      class FooterModel < BaseModel

        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------

        #=============== DATA ACCESSORS =======================

        def contents
          @contents ||= []
        end

        # Images and links in the footer are registered with the document,
        # which numbers them and writes the media, but Word resolves them
        # against the footer part's own relationships. The renderer collects
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

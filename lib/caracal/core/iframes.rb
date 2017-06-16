require 'caracal/core/models/iframe_model'
require 'caracal/errors'


module Caracal
  module Core

    # This module encapsulates all the functionality related to inserting
    # word document snippets into the document.
    #
    module IFrames
      def self.included(base)
        base.class_eval do

          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          def iframe(options={}, &block)
            model = Caracal::Core::Models::IFrameModel.new(options, &block)
            if model.valid?
              model.preprocess!
              model.namespaces.each do |(prefix, href)|
                namespace({ prefix: prefix, href: href })
              end
              model.ignorables.each do |prefix|
                ignorable(prefix)
              end

              contents << model
            else
              raise Caracal::Errors::InvalidModelError, 'IFrameModel requires either the :url or :data argument.'
            end
            model
          end

        end
      end
    end

  end
end

require 'caracal/core/models/header_model'
require 'caracal/errors'




module Caracal
  module Core


    module Headers
      def self.included(base)
        base.class_eval do
          const_set(:DEFAULT_HEADER_ALIGN, :center)
            
          attr_reader :header_align
          attr_reader :header_text
          attr_reader :header_show



          def headers(*args, &block)
            options = Caracal::Utilities.extract_options!(args)
            options.merge!({ show: !!args.first }) unless args.first.nil?  # careful: falsey value

            model = Caracal::Core::Models::HeaderModel.new(options, &block) 
            if model.valid?
              @header_align = model.header_align
              @header_text  = model.header_text
              @header_show  = model.header_show
            else
              raise Caracal::Errors::InvalidModelError, 'headers :align parameter must be :left, :center, or :right'
            end
          end
        end
      end
    end
  end
end

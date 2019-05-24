require 'caracal/core/models/base_model'



module Caracal
  module Core
    module Models



      class HeaderModel < BaseModel

        const_set(:DEFAULT_HEADER_ALIGN, :center)
        const_set(:DEFAULT_HEADER_SHOW,  false  )

        attr_reader :header_align
        attr_reader :header_text
        attr_reader :header_show


        def initialize(options={}, &block)
          @header_align = DEFAULT_HEADER_ALIGN 
          @header_text  = nil
          @header_show  = DEFAULT_HEADER_SHOW

          super options,&block
        end

        def align(value)
          @header_align = value.to_s.to_sym
        end
        

        def text(value)
          @header_text = value.to_s.strip
        end

        def show(value)
          @header_show = !!value
        end




        def valid?
          (!header_show || [:left, :center, :right].include?(header_align))
        end


        private

        def option_keys
          [:align, :label, :show]
        end
      end
    end
  end
end

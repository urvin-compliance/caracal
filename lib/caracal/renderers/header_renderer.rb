require 'nokogiri'

require 'caracal/renderers/header_footer_renderer'


module Caracal
  module Renderers
    class HeaderRenderer < HeaderFooterRenderer

      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------

      # This method produces the xml required for the `word/header1.xml`
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml['w'].hdr root_options do
            render_contents(xml)
          end
        end
        builder.to_xml(save_options)
      end


      #-------------------------------------------------------------
      # Private Methods
      #-------------------------------------------------------------
      private

      def part_content
        document.header_content
      end

    end
  end
end

require 'nokogiri'

require 'caracal/renderers/document_renderer'


module Caracal
  module Renderers

    # This class holds what the header and footer renderers share: they
    # render the same models as the document body, but into a part with
    # its own relationships.
    #
    class HeaderFooterRenderer < DocumentRenderer

      #-------------------------------------------------------------
      # Private Methods
      #-------------------------------------------------------------
      private

      # This method returns the HeaderModel or FooterModel being rendered.
      # A concrete implementation must be provided by the subclass.
      #
      def part_content
        raise NotImplementedError, 'header and footer renderers must implement the method :part_content.'
      end

      def render_contents(xml)
        part_content.relationships.clear
        part_content.contents.each do |model|
          method = render_method_for_model(model)
          send(method, xml, model)
        end
      end

      # The document still assigns the id, so ids and media names stay unique
      # across parts, but the part records the relationship for its own rels.
      #
      def relationship(options)
        rel  = document.relationship(options)
        rels = part_content.relationships
        rels << rel unless rels.include?(rel)
        rel
      end

      def root_options
        {
          'xmlns:mc'  => 'http://schemas.openxmlformats.org/markup-compatibility/2006',
          'xmlns:o'   => 'urn:schemas-microsoft-com:office:office',
          'xmlns:r'   => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
          'xmlns:m'   => 'http://schemas.openxmlformats.org/officeDocument/2006/math',
          'xmlns:v'   => 'urn:schemas-microsoft-com:vml',
          'xmlns:wp'  => 'http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing',
          'xmlns:w10' => 'urn:schemas-microsoft-com:office:word',
          'xmlns:w'   => 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
          'xmlns:wne' => 'http://schemas.microsoft.com/office/word/2006/wordml',
          'xmlns:sl'  => 'http://schemas.openxmlformats.org/schemaLibrary/2006/main',
          'xmlns:a'   => 'http://schemas.openxmlformats.org/drawingml/2006/main',
          'xmlns:pic' => 'http://schemas.openxmlformats.org/drawingml/2006/picture',
          'xmlns:c'   => 'http://schemas.openxmlformats.org/drawingml/2006/chart',
          'xmlns:lc'  => 'http://schemas.openxmlformats.org/drawingml/2006/lockedCanvas',
          'xmlns:dgm' => 'http://schemas.openxmlformats.org/drawingml/2006/diagram'
        }
      end

    end
  end
end

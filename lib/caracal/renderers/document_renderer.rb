module Caracal
  module Renderers
    class DocumentRenderer < XmlRenderer
      
      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------
      
      # This method produces the xml required for the `word/document.xml` 
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml.send 'w:document', root_options do
            xml.send 'w:background', { 'w:color' => 'FFFFFF' }
            xml.send 'w:body' do
              xml.send 'w:sectPr' do
                if document.page_number_show
                  if rel = document.relationship_for_target('footer1.xml')
                    xml.send 'w:footerReference', { 'r:id' => rel.formatted_id, 'w:type' => 'default' }
                  end
                end
                xml.send 'w:pgSz', page_size_options
                xml.send 'w:pgMar', page_margin_options
              end
            end
          end
        end
        builder.to_xml(save_options)
      end
      
      
      #-------------------------------------------------------------
      # Private Methods
      #------------------------------------------------------------- 
      private
      
      def root_options
        {
          'xmlns:mc'   => 'http://schemas.openxmlformats.org/markup-compatibility/2006',
          'xmlns:o'    => 'urn:schemas-microsoft-com:office:office',
          'xmlns:r'    => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
          'xmlns:m'    => 'http://schemas.openxmlformats.org/officeDocument/2006/math',
          'xmlns:v'    => 'urn:schemas-microsoft-com:vml',
          'xmlns:wp'   => 'http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing',
          'xmlns:w10'  => 'urn:schemas-microsoft-com:office:word',
          'xmlns:w'    => 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
          'xmlns:wne'  => 'http://schemas.microsoft.com/office/word/2006/wordml',
          'xmlns:sl'   => 'http://schemas.openxmlformats.org/schemaLibrary/2006/main',
          'xmlns:a'    => 'http://schemas.openxmlformats.org/drawingml/2006/main',
          'xmlns:pic'  => 'http://schemas.openxmlformats.org/drawingml/2006/picture',
          'xmlns:c'    => 'http://schemas.openxmlformats.org/drawingml/2006/chart',
          'xmlns:lc'   => 'http://schemas.openxmlformats.org/drawingml/2006/lockedCanvas',
          'xmlns:dgm'  => 'http://schemas.openxmlformats.org/drawingml/2006/diagram'
        }
      end
      
      def page_margin_options
        { 
          'w:top'    => document.page_margin_top, 
          'w:bottom' => document.page_margin_bottom, 
          'w:left'   => document.page_margin_left, 
          'w:right'  => document.page_margin_right 
        }
      end
      
      def page_size_options
        { 
          'w:w' => document.page_width, 
          'w:h' => document.page_height 
        }
      end
   
    end
  end
end
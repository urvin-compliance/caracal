require 'nokogiri'

require 'caracal/renderers/xml_renderer'


module Caracal
  module Renderers
    class FooterRenderer < XmlRenderer
      
      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------
      
      # This method produces the xml required for the `word/settings.xml` 
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml.send 'w:ftr', root_options do
            xml.send 'w:p', paragraph_options do
              xml.send 'w:pPr' do
                xml.send 'w:contextualSpacing', { 'w:val' => '0' }
                xml.send 'w:jc', { 'w:val' => "#{ document.page_number_align }" }
              end
              if document.page_number_text.present?
                xml.send 'w:r', run_options do
                  xml.send 'w:rPr' do
                    xml.send 'w:rStyle', { 'w:val' => 'PageNumber' }
                  end
                  xml.send 'w:t', { 'xml:space' => 'preserve' } do
                    # Ensure there is a space at the end to separate the label from the page number
                    xml.text "#{document.page_number_label} "
                  end
                end
              end
              xml.send 'w:fldSimple', { 'w:dirty' => '0', 'w:instr' => 'PAGE', 'w:fldLock' => '0' } do
                xml.send 'w:r', run_options do
                  xml.send 'w:rPr'
                end
              end
              xml.send 'w:r', run_options do
                xml.send 'w:rPr' do
                  xml.send 'w:rtl', { 'w:val' => '0' }
                end
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
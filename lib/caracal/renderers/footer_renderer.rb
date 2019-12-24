require 'nokogiri'

require 'caracal/renderers/xml_renderer'


module Caracal
  module Renderers
    class FooterRenderer < DocumentRenderer

      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------

      # This method produces the xml required for the `word/settings.xml`
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          if document.page_number_show
            xml['w'].ftr root_options do
              xml['w'].p paragraph_options do
                xml['w'].pPr do
                  xml['w'].contextualSpacing({ 'w:val' => '0' })
                  xml['w'].jc({ 'w:val' => "#{ document.page_number_align }" })
                end
                unless document.page_number_label.nil?
                  xml['w'].r run_options do
                    xml['w'].rPr do
                      xml['w'].rStyle({ 'w:val' => 'PageNumber' })
                      unless document.page_number_label_size.nil?
                        xml['w'].sz({ 'w:val'  => document.page_number_label_size })
                      end
                    end
                    xml['w'].t({ 'xml:space' => 'preserve' }) do
                      xml.text "#{ document.page_number_label } "
                    end
                  end
                end
                xml['w'].r run_options do
                  xml['w'].rPr do
                    unless document.page_number_number_size.nil?
                      xml['w'].sz({ 'w:val'  => document.page_number_number_size })
                      xml['w'].szCs({ 'w:val' => document.page_number_number_size })
                    end
                  end
                  xml['w'].fldChar({ 'w:fldCharType' => 'begin' })
                  xml['w'].instrText({ 'xml:space' => 'preserve' }) do
                    xml.text 'PAGE'
                  end
                  xml['w'].fldChar({ 'w:fldCharType' => 'end' })
                end
                xml['w'].r run_options do
                  xml['w'].rPr do
                    xml['w'].rtl({ 'w:val' => '0' })
                  end
                end
              end
            end
          elsif document.footer_content.present? && document.footer_content.valid?
            xml['w'].ftr root_options do

              #============= CONTENTS ===================================

              document.footer_content.contents.each do |model|
                method = render_method_for_model(model)
                send(method, xml, model)
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

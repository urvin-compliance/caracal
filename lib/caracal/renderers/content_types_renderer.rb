require 'nokogiri'

require 'caracal/renderers/xml_renderer'


module Caracal
  module Renderers
    class ContentTypesRenderer < XmlRenderer

      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------

      # This method produces the xml required for the `_[ContentTypes].xml`
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml.send 'Types', root_options do
            xml.send 'Default', { 'Extension' => 'gif',  'ContentType' => 'image/gif' }
            xml.send 'Default', { 'Extension' => 'jpeg', 'ContentType' => 'image/jpeg' }
            xml.send 'Default', { 'Extension' => 'jpg',  'ContentType' => 'image/jpeg' }
            xml.send 'Default', { 'Extension' => 'png',  'ContentType' => 'image/png' }
            xml.send 'Default', { 'Extension' => 'rels', 'ContentType' => 'application/vnd.openxmlformats-package.relationships+xml' }
            xml.send 'Default', { 'Extension' => 'xml',  'ContentType' => 'application/xml' }
            xml.send 'Override', { 'PartName' => '/docProps/app.xml',    'ContentType' => 'application/vnd.openxmlformats-officedocument.extended-properties+xml' }
            xml.send 'Override', { 'PartName' => '/docProps/core.xml',   'ContentType' => 'application/vnd.openxmlformats-package.core-properties+xml' }
            xml.send 'Override', { 'PartName' => '/docProps/custom.xml', 'ContentType' => 'application/vnd.openxmlformats-officedocument.custom-properties+xml' }
            xml.send 'Override', { 'PartName' => '/word/document.xml',   'ContentType' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml' }
            xml.send 'Override', { 'PartName' => '/word/footer1.xml',    'ContentType' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.footer+xml' }
            xml.send 'Override', { 'PartName' => '/word/header1.xml',    'ContentType' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.header+xml' }
            xml.send 'Override', { 'PartName' => '/word/fontTable.xml',  'ContentType' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.fontTable+xml' }
            xml.send 'Override', { 'PartName' => '/word/numbering.xml',  'ContentType' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.numbering+xml' }
            xml.send 'Override', { 'PartName' => '/word/settings.xml',   'ContentType' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.settings+xml' }
            xml.send 'Override', { 'PartName' => '/word/styles.xml',     'ContentType' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml' }
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
          'xmlns' => 'http://schemas.openxmlformats.org/package/2006/content-types'
        }
      end

    end
  end
end

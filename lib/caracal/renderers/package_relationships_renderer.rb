require 'nokogiri'

require 'caracal/renderers/xml_renderer'


module Caracal
  module Renderers
    class PackageRelationshipsRenderer < XmlRenderer
      
      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------
      
      # This method produces the xml required for the `word/settings.xml` 
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml.send 'Relationships', root_options do
            relationship_data.each_with_index do |rel, index|
              xml.send 'Relationship', { 'Target' => rel.first, 'Type' => rel.last, 'Id' => "rId#{ index + 1 }" }
            end
          end
        end
        builder.to_xml(save_options)
      end
      
      
      #-------------------------------------------------------------
      # Private Methods
      #------------------------------------------------------------- 
      private
      
      def relationship_data
        [
          ['docProps/app.xml',  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties'],
          ['docProps/core.xml', 'http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties'],
          ['word/document.xml', 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument']
        ]
      end
      
      def root_options
        {
          'xmlns' => 'http://schemas.openxmlformats.org/package/2006/relationships'
        }
      end
   
    end
  end
end
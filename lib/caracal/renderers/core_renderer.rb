module Caracal
  module Renderers
    class CoreRenderer < XmlRenderer
      
      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------
      
      # This method produces the xml required for the `docProps/core.xml` 
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml.send 'cp:coreProperties', root_options do
            xml['dc'].title document.name
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
          'xmlns:cp'        => 'http://schemas.openxmlformats.org/package/2006/metadata/core-properties',
          'xmlns:dc'        => 'http://purl.org/dc/elements/1.1/',
          'xmlns:dcterms'   => 'http://purl.org/dc/terms/',
          'xmlns:dcmitype'  => 'http://purl.org/dc/dcmitype/',
          'xmlns:xsi'       => 'http://www.w3.org/2001/XMLSchema-instance'
        }
      end
   
    end
  end
end
module Caracal
  module Renderers
    class AppRenderer < XmlRenderer
      
      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------
      
      # This method produces the xml required for the `docProps/app.xml` 
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml.send 'Properties', root_options do
            xml.send 'Application', 'Caracal'
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
          'xmlns'    => 'http://schemas.openxmlformats.org/officeDocument/2006/extended-properties',
          'xmlns:vt' => 'http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes'
        }
      end
   
    end
  end
end
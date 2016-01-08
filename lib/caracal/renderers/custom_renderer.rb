require 'nokogiri'
require 'date'

require 'caracal/renderers/xml_renderer'


module Caracal
  module Renderers
    class CustomRenderer < XmlRenderer

      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------

      # This method produces the xml required for the `docProps/custom.xml`
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml.send 'Properties', root_options do
            document.custom_props.each_with_index do |property, index|
              xml.send 'property',
                { fmtid: '{D5CDD505-2E9C-101B-9397-08002B2CF9AE}', pid: index + 2, name: property.custom_property_name } do
                  case property.custom_property_type.downcase
                  when  'text'
                    xml['vt'].lpwstr property.custom_property_value
                  when 'date'
                    xml['vt'].filetime property.custom_property_value.to_date
                  when 'number'
                    xml['vt'].i4 property.custom_property_value.to_f
                  when 'boolean'
                    if property.custom_property_value == 'true' || property.custom_property_value == 'false'
                      xml['vt'].bool property.custom_property_value
                    else
                      # Not a boolean sent, so reverting to string so docx will open
                      xml['vt'].lpwstr property.custom_property_value
                    end
                  else
                    # Fail to string type
                    xml['vt'].lpwstr property.custom_property_value
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
          'xmlns'        => "http://schemas.openxmlformats.org/officeDocument/2006/custom-properties",
          'xmlns:vt'     => "http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes"
        }
      end

    end
  end
end

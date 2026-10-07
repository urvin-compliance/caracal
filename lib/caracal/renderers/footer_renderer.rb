require 'nokogiri'

require 'caracal/renderers/header_footer_renderer'


module Caracal
  module Renderers
    class FooterRenderer < HeaderFooterRenderer

      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------

      # This method produces the xml required for a footer sub-document,
      # such as `word/footer1.xml`. Footer content comes first, then the
      # page number.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml['w'].ftr root_options do
            render_contents(xml) if part_content

            if @page_number
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
                      xml.text "#{ xml_safe(document.page_number_label) } "
                    end
                  end
                end
                # A complex field is a *sequence* of runs: a begin character, the
                # instruction text, a separate character, and an end character.
                # Packing them into a single run, or omitting the separate
                # character, leaves viewers that do not evaluate fields showing
                # the raw instruction ("PAGE") instead of the page number.
                xml['w'].r run_options do
                  render_number_properties(xml)
                  xml['w'].fldChar({ 'w:fldCharType' => 'begin' })
                end
                xml['w'].r run_options do
                  render_number_properties(xml)
                  xml['w'].instrText({ 'xml:space' => 'preserve' }) do
                    xml.text ' PAGE '
                  end
                end
                xml['w'].r run_options do
                  render_number_properties(xml)
                  xml['w'].fldChar({ 'w:fldCharType' => 'separate' })
                end
                xml['w'].r run_options do
                  render_number_properties(xml)
                  xml['w'].fldChar({ 'w:fldCharType' => 'end' })
                end
                xml['w'].r run_options do
                  xml['w'].rPr do
                    xml['w'].rtl({ 'w:val' => '0' })
                  end
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

      # This method renders the run properties shared by every run of the
      # page number field, so the result Word computes is sized correctly.
      #
      def render_number_properties(xml)
        xml['w'].rPr do
          unless document.page_number_number_size.nil?
            xml['w'].sz({ 'w:val'  => document.page_number_number_size })
            xml['w'].szCs({ 'w:val' => document.page_number_number_size })
          end
        end
      end

    end
  end
end

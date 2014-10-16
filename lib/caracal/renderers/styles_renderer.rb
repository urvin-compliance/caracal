require 'nokogiri'

require 'caracal/renderers/xml_renderer'
require 'caracal/errors'


module Caracal
  module Renderers
    class StylesRenderer < XmlRenderer

      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------

      # This method produces the xml required for the `word/styles.xml`
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml.send 'w:styles', root_options do

            #============ DEFAULT STYLES ================================

            unless s = document.default_style
              raise Caracal::Errors::NoDefaultStyleError 'Document must declare a default paragraph style.'
            end
            xml.send 'w:docDefaults' do
              xml.send 'w:rPrDefault' do
                xml.send 'w:rPr' do
                  xml.send 'w:rFonts',    font_options(s)
                  xml.send 'w:b',         { 'w:val' => (s.style_bold ? '1' : '0') }
                  xml.send 'w:i',         { 'w:val' => (s.style_italic ? '1' : '0') }
                  xml.send 'w:caps',      { 'w:val' => (s.style_caps ? '1' : '0') }
                  xml.send 'w:smallCaps', { 'w:val' => '0' }
                  xml.send 'w:strike',    { 'w:val' => '0' }
                  xml.send 'w:color',     { 'w:val' => s.style_color }
                  xml.send 'w:sz',        { 'w:val' => s.style_size }
                  xml.send 'w:u',         { 'w:val' => (s.style_underline ? 'single' : 'none') }
                  xml.send 'w:vertAlign', { 'w:val' => 'baseline' }
                end
              end
              xml.send 'w:pPrDefault' do
                xml.send 'w:pPr' do
                  xml.send 'w:keepNext',     { 'w:val' => '0' }
                  xml.send 'w:keepLines',    { 'w:val' => '0' }
                  xml.send 'w:widowControl', { 'w:val' => '1' }
                  xml.send 'w:spacing',      spacing_options(s, true)
                  xml.send 'w:ind',          { 'w:left' => '0', 'w:firstLine' => '0', 'w:right' => '0' }
                  xml.send 'w:jc',           { 'w:val' => s.style_align.to_s }
                end
              end
            end
            xml.send 'w:style', { 'w:styleId' => s.style_id, 'w:type' => 'paragraph', 'w:default' => '1' } do
              xml.send 'w:name', { 'w:val' => s.style_name }
            end
            xml.send 'w:style', { 'w:styleId' => 'TableNormal', 'w:type' => 'table', 'w:default' => '1' } do
              xml.send 'w:name', { 'w:val' => 'Table Normal'}
              xml.send 'w:pPr' do
                xml.send 'w:spacing', { 'w:lineRule' => 'auto', 'w:line' => (s.style_size * 20 * 1.15), 'w:before' => '0', 'w:after' => '0' }
              end
            end
            default_id = s.style_id


            #============ PARAGRAPH STYLES ================================

            document.styles.reject { |s| s.style_id == default_id }.each do |s|
              xml.send 'w:style', { 'w:styleId' => s.style_id, 'w:type' => 'paragraph' } do
                xml.send 'w:name',    { 'w:val' => s.style_name }
                xml.send 'w:basedOn', { 'w:val' => s.style_base }
                xml.send 'w:next',    { 'w:val' => s.style_next }
                xml.send 'w:pPr' do
                  xml.send 'w:keepNext',          { 'w:val' => '0' }
                  xml.send 'w:keepLines',         { 'w:val' => '0' }
                  xml.send 'w:widowControl',      { 'w:val' => '1' }
                  xml.send 'w:spacing',           spacing_options(s)                              unless spacing_options(s).nil?
                  xml.send 'w:contextualSpacing', { 'w:val' => '1' }
                  xml.send 'w:jc',                { 'w:val' => s.style_align.to_s }               unless s.style_align.nil?
                end
                xml.send 'w:rPr' do
                  xml.send 'w:rFonts',    font_options(s)                                         unless s.style_font.nil?
                  xml.send 'w:b',         { 'w:val' => (s.style_bold ? '1' : '0') }               unless s.style_bold.nil?
                  xml.send 'w:i',         { 'w:val' => (s.style_italic ? '1' : '0') }             unless s.style_italic.nil?
                  xml.send 'w:caps',      { 'w:val' => (s.style_caps ? '1' : '0') }               unless s.style_caps.nil?
                  xml.send 'w:color',     { 'w:val' => s.style_color }                            unless s.style_color.nil?
                  xml.send 'w:sz',        { 'w:val' => s.style_size }                             unless s.style_size.nil?
                  xml.send 'w:u',         { 'w:val' => (s.style_underline ? 'single' : 'none') }  unless s.style_underline.nil?
                end
              end
            end

            #============ TABLE STYLES ================================

            xml.send 'w:style', { 'w:styleId' => 'DefaultTable', 'w:type' => 'table' } do
              xml.send 'w:basedOn', { 'w:val' => 'TableNormal' }
              xml.send 'w:tblPr' do
                xml.send 'w:tblStyleRowBandSize', { 'w:val' => '1' }
                xml.send 'w:tblStyleColBandSize', { 'w:val' => '1' }
              end
              %w(band1Horz band1Vert band2Horz band2Vert).each do |type|
                xml.send 'w:tblStylePr', { 'w:type' => type }
              end
              %w(firstCol firstRow lastCol lastRow).each do |type|
                xml.send 'w:tblStylePr', { 'w:type' => type }
              end
              %w(neCell nwCell seCell swCell).each do |type|
                xml.send 'w:tblStylePr', { 'w:type' => type }
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

      def font_options(style)
        name = style.style_font
        { 'w:cs' => name, 'w:hAnsi' => name, 'w:eastAsia' => name, 'w:ascii' => name }
      end

      def spacing_options(style, default=false)
        top     = (default) ? style.style_top.to_i    : style.style_top
        bottom  = (default) ? style.style_bottom.to_i : style.style_bottom
        line    = style.style_line

        options = nil
        if [top, bottom, line].compact.size > 0
          options               = {}
          options['w:lineRule'] = 'auto'
          options['w:before']   = top      unless top.nil?
          options['w:after']    = bottom   unless bottom.nil?
          options['w:line']     = line     unless line.nil?
        end
        options
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

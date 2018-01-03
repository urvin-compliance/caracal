require 'nokogiri'

require 'caracal/renderers/xml_renderer'
require 'caracal/errors'


module Caracal
  module Renderers
    class StylesRenderer < XmlRenderer

      #----------------------------------------------------
      # Public Methods
      #----------------------------------------------------

      # This method produces the xml required for the `word/styles.xml`
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml['w'].styles root_options do

            #========== DEFAULT STYLES ====================

            unless s = document.default_style
              raise Caracal::Errors::NoDefaultStyleError 'Document must declare a default paragraph style.'
            end
            xml['w'].docDefaults do
              xml['w'].rPrDefault do
                xml['w'].rPr do
                  xml['w'].rFonts font_options(s)
                  xml['w'].b({ 'w:val' => (s.style_bold ? '1' : '0') })
                  xml['w'].i({ 'w:val' => (s.style_italic ? '1' : '0') })
                  xml['w'].caps({ 'w:val' => (s.style_caps ? '1' : '0') })
                  xml['w'].smallCaps({ 'w:val' => '0' })
                  xml['w'].strike({ 'w:val' => '0' })
                  xml['w'].color({ 'w:val' => s.style_color })
                  xml['w'].sz({ 'w:val' => s.style_size })
                  xml['w'].u({ 'w:val' => (s.style_underline ? 'single' : 'none') })
                  xml['w'].vertAlign({ 'w:val' => 'baseline' })
                end
              end
              xml['w'].pPrDefault do
                xml['w'].pPr do
                  xml['w'].keepNext({ 'w:val' => '0' })
                  xml['w'].keepLines({ 'w:val' => '0' })
                  xml['w'].widowControl({ 'w:val' => '1' })
                  xml['w'].spacing(spacing_options(s, true))
                  xml['w'].ind(indentation_options(s, true))
                  xml['w'].jc({ 'w:val' => s.style_align.to_s })
                end
              end
            end
            xml['w'].style({ 'w:styleId' => s.style_id, 'w:type' => 'paragraph', 'w:default' => '1' }) do
              xml['w'].name({ 'w:val' => s.style_name })
            end
            xml['w'].style({ 'w:styleId' => 'TableNormal', 'w:type' => 'table', 'w:default' => '1' }) do
              xml['w'].name({ 'w:val' => 'Table Normal'})
              xml['w'].pPr do
                xml['w'].spacing({ 'w:lineRule' => 'auto', 'w:line' => (s.style_size * 20 * 1.15), 'w:before' => '0', 'w:after' => '0' })
              end
            end
            default_id = s.style_id


            #========== PARA/CHAR STYLES ==================

            document.styles.reject { |s| s.style_id == default_id }.each do |s|
              xml['w'].style({ 'w:styleId' => s.style_id, 'w:type' => s.style_type }) do
                xml['w'].name({ 'w:val' => s.style_name })
                xml['w'].basedOn({ 'w:val' => s.style_base })
                xml['w'].next({ 'w:val' => s.style_next })
                xml['w'].pPr do
                  xml['w'].keepNext({ 'w:val' => '0' })
                  xml['w'].keepLines({ 'w:val' => '0' })
                  xml['w'].widowControl({ 'w:val' => '1' })
                  xml['w'].spacing(spacing_options(s)) unless spacing_options(s).nil?
                  xml['w'].contextualSpacing({ 'w:val' => '1' })
                  xml['w'].jc({ 'w:val' => s.style_align.to_s }) unless s.style_align.nil?
                  xml['w'].ind(indentation_options(s)) unless indentation_options(s).nil?
                end
                xml['w'].rPr do
                  xml['w'].rFonts(font_options(s)) unless s.style_font.nil?
                  xml['w'].b({ 'w:val' => (s.style_bold ? '1' : '0') } ) unless s.style_bold.nil?
                  xml['w'].i({ 'w:val' => (s.style_italic ? '1' : '0') }) unless s.style_italic.nil?
                  xml['w'].caps({ 'w:val' => (s.style_caps ? '1' : '0') }) unless s.style_caps.nil?
                  xml['w'].color({ 'w:val' => s.style_color }) unless s.style_color.nil?
                  xml['w'].sz({ 'w:val' => s.style_size }) unless s.style_size.nil?
                  xml['w'].u({ 'w:val' => (s.style_underline ? 'single' : 'none') }) unless s.style_underline.nil?
                end
              end
            end

            #========== TABLE STYLES ======================

            xml['w'].style({ 'w:styleId' => 'DefaultTable', 'w:type' => 'table' }) do
              xml['w'].basedOn({ 'w:val' => 'TableNormal' })
              xml['w'].tblPr do
                xml['w'].tblStyleRowBandSize({ 'w:val' => '1' })
                xml['w'].tblStyleColBandSize({ 'w:val' => '1' })
              end
              %w(band1Horz band1Vert band2Horz band2Vert).each do |type|
                xml['w'].tblStylePr({ 'w:type' => type })
              end
              %w(firstCol firstRow lastCol lastRow).each do |type|
                xml['w'].tblStylePr({ 'w:type' => type })
              end
              %w(neCell nwCell seCell swCell).each do |type|
                xml['w'].tblStylePr({ 'w:type' => type })
              end
            end

          end
        end
        builder.to_xml(save_options)
      end



      #----------------------------------------------------
      # Private Methods
      #----------------------------------------------------
      private

      def font_options(style)
        name = style.style_font
        { 'w:cs' => name, 'w:hAnsi' => name, 'w:eastAsia' => name, 'w:ascii' => name }
      end

      def indentation_options(style, default=false)
        left    = (default) ? style.style_indent_left.to_i  : style.style_indent_left
        right   = (default) ? style.style_indent_right.to_i : style.style_indent_right
        first   = (default) ? style.style_indent_first.to_i : style.style_indent_first
        options = nil
        if [left, right, first].compact.size > 0
          options                  = {}
          options['w:left']        = left    unless left.nil?
          options['w:right']       = right   unless right.nil?
          options['w:firstLine']   = first   unless first.nil?
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

    end
  end
end

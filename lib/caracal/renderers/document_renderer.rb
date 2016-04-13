require 'nokogiri'

require 'caracal/renderers/xml_renderer'
require 'caracal/errors'


module Caracal
  module Renderers
    class DocumentRenderer < XmlRenderer

      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------

      # This method produces the xml required for the `word/document.xml`
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml.send 'w:document', root_options do
            xml.send 'w:background', { 'w:color' => 'FFFFFF' }
            xml.send 'w:body' do

              #============= CONTENTS ===================================

              document.contents.each do |model|
                method = render_method_for_model(model)
                send(method, xml, model)
              end

              #============= PAGE SETTINGS ==============================

              xml.send 'w:sectPr' do
                if document.page_number_show
                  if rel = document.find_relationship('footer1.xml')
                    xml.send 'w:footerReference', { 'r:id' => rel.formatted_id, 'w:type' => 'default' }
                  end
                end
                xml.send 'w:pgSz', page_size_options
                xml.send 'w:pgMar', page_margin_options
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

      #============= COMMON RENDERERS ==========================

      # This method converts a model class name to a rendering
      # function on this class (e.g., Caracal::Core::Models::ParagraphModel
      # translates to `render_paragraph`).
      #
      def render_method_for_model(model)
        type = model.class.name.split('::').last.downcase.gsub('model', '')
        "render_#{ type }"
      end

      # This method renders a standard node of run properties based on the
      # model's attributes.
      #
      def render_run_attributes(xml, model, paragraph_level=false)
        if model.respond_to? :run_attributes
          attrs = model.run_attributes.delete_if { |k, v| v.nil? }

          if paragraph_level && attrs.empty?
            # skip
          else
            xml.send 'w:rPr' do
              unless attrs.empty?
                xml.send 'w:rStyle',    { 'w:val'  => attrs[:style] }                            unless attrs[:style].nil?
                xml.send 'w:color',     { 'w:val'  => attrs[:color] }                            unless attrs[:color].nil?
                xml.send 'w:sz',        { 'w:val'  => attrs[:size]  }                            unless attrs[:size].nil?
                xml.send 'w:b',         { 'w:val'  => (attrs[:bold] ? '1' : '0') }               unless attrs[:bold].nil?
                xml.send 'w:i',         { 'w:val'  => (attrs[:italic] ? '1' : '0') }             unless attrs[:italic].nil?
                xml.send 'w:u',         { 'w:val'  => (attrs[:underline] ? 'single' : 'none') }  unless attrs[:underline].nil?
                xml.send 'w:shd',       { 'w:fill' => attrs[:bgcolor], 'w:val' => 'clear' }      unless attrs[:bgcolor].nil?
                xml.send 'w:vertAlign', { 'w:val' => attrs[:vertical_align] }                    unless attrs[:vertical_align].nil?
                unless attrs[:font].nil?
                  f = attrs[:font]
                  xml.send 'w:rFonts', { 'w:ascii' => f, 'w:hAnsi' => f, 'w:eastAsia' => f, 'w:cs' => f }
                end
              end
              xml.send 'w:rtl',    { 'w:val' => '0' }
            end
          end
        end
      end


      #============= MODEL RENDERERS ===========================

      def render_image(xml, model)
        unless ds = document.default_style
          raise Caracal::Errors::NoDefaultStyleError 'Document must declare a default paragraph style.'
        end

        rel      = document.relationship({ type: :image, target: model.image_url, data: model.image_data })
        rel_id   = rel.relationship_id
        rel_name = rel.formatted_target

        xml.send 'w:p', paragraph_options do
          xml.send 'w:pPr' do
            xml.send 'w:spacing', { 'w:lineRule' => 'auto', 'w:line' => ds.style_line }
            xml.send 'w:contextualSpacing', { 'w:val' => '0' }
            xml.send 'w:jc', { 'w:val' => model.image_align.to_s }
            xml.send 'w:rPr'
          end
          xml.send 'w:r', run_options do
            xml.send 'w:drawing' do
              xml.send 'wp:inline', { distR: model.formatted_right, distT: model.formatted_top, distB: model.formatted_bottom, distL: model.formatted_left } do
                xml.send 'wp:extent', { cx: model.formatted_width, cy: model.formatted_height }
                xml.send 'wp:effectExtent', { t: 0, b: 0, r: 0, l: 0 }
                xml.send 'wp:docPr', { id: rel_id, name: rel_name }
                xml.send 'a:graphic' do
                  xml.send 'a:graphicData', { uri: 'http://schemas.openxmlformats.org/drawingml/2006/picture' } do
                    xml.send 'pic:pic' do
                      xml.send 'pic:nvPicPr' do
                        xml.send 'pic:cNvPr', { id: rel_id, name: rel_name }
                        xml.send 'pic:cNvPicPr'
                      end
                      xml.send 'pic:blipFill' do
                        xml.send 'a:blip', { 'r:embed' => rel.formatted_id }
                        xml.send 'a:srcRect'
                        xml.send 'a:stretch' do
                          xml.send 'a:fillRect'
                        end
                      end
                      xml.send 'pic:spPr' do
                        xml.send 'a:xfrm' do
                          xml.send 'a:ext', { cx: model.formatted_width, cy: model.formatted_height }
                        end
                        xml.send 'a:prstGeom', { prst: 'rect' }
                        xml.send 'a:ln'
                      end
                    end
                  end
                end
              end
            end
          end
          xml.send 'w:r', run_options do
            xml.send 'w:rPr' do
              xml.send 'w:rtl', { 'w:val' => '0' }
            end
          end
        end
      end

      def render_linebreak(xml, model)
        xml.send 'w:r' do
          xml.send 'w:br'
        end
      end

      def render_link(xml, model)
        rel = document.relationship({ target: model.link_href, type: :link })

        xml.send 'w:hyperlink', { 'r:id' => rel.formatted_id } do
          xml.send 'w:r', run_options do
            render_run_attributes(xml, model, false)
            xml.send 'w:t', { 'xml:space' => 'preserve' }, model.link_content
          end
        end
      end

      def render_list(xml, model)
        if model.list_level == 0
          document.toplevel_lists << model
          list_num = document.toplevel_lists.length   # numbering uses 1-based index
        end

        model.recursive_items.each do |item|
          render_listitem(xml, item, list_num)
        end
      end

      def render_listitem(xml, model, list_num)
        ls      = document.find_list_style(model.list_item_type, model.list_item_level)
        hanging = ls.style_left.to_i - ls.style_indent.to_i - 1

        xml.send 'w:p', paragraph_options do
          xml.send 'w:pPr' do
            xml.send 'w:numPr' do
              xml.send 'w:ilvl', { 'w:val' => model.list_item_level }
              xml.send 'w:numId', { 'w:val' => list_num }
            end
            xml.send 'w:ind', { 'w:left' => ls.style_left, 'w:hanging' => hanging }
            xml.send 'w:contextualSpacing', { 'w:val' => '1' }
            xml.send 'w:rPr' do
              xml.send 'w:u', { 'w:val' => 'none' }
            end
          end
          model.runs.each do |run|
            method = render_method_for_model(run)
            send(method, xml, run)
          end
        end
      end

      def render_pagebreak(xml, model)
        if model.page_break_wrap
          xml.send 'w:p', paragraph_options do
            xml.send 'w:r', run_options do
              xml.send 'w:br', { 'w:type' => 'page' }
            end
          end
        else
          xml.send 'w:r', run_options do
            xml.send 'w:br', { 'w:type' => 'page' }
          end
        end
      end

      def render_paragraph(xml, model)
        run_props = [:color, :size, :bold, :italic, :underline].map { |m| model.send("paragraph_#{ m }") }.compact

        xml.send 'w:p', paragraph_options do
          xml.send 'w:pPr' do
            xml.send 'w:pStyle',            { 'w:val' => model.paragraph_style }  unless model.paragraph_style.nil?
            xml.send 'w:contextualSpacing', { 'w:val' => '0' }
            xml.send 'w:jc',                { 'w:val' => model.paragraph_align }  unless model.paragraph_align.nil?
            render_run_attributes(xml, model, true)
          end
          model.runs.each do |run|
            method = render_method_for_model(run)
            send(method, xml, run)
          end
        end
      end

      def render_rule(xml, model)
        options = { 'w:color' => model.rule_color, 'w:sz' => model.rule_size, 'w:val' => model.rule_line, 'w:space' => model.rule_spacing }

        xml.send 'w:p', paragraph_options do
          xml.send 'w:pPr' do
            xml.send 'w:pBdr' do
              xml.send 'w:top', options
            end
          end
        end
      end

      def render_text(xml, model)
        xml.send 'w:r', run_options do
          render_run_attributes(xml, model, false)
          xml.send 'w:t', { 'xml:space' => 'preserve' }, model.text_content
        end
      end

      def render_table(xml, model)
        borders = %w(top left bottom right horizontal vertical).select do |m|
          model.send("table_border_#{ m }_size") > 0
        end

        xml.send 'w:tbl' do
          xml.send 'w:tblPr' do
            xml.send 'w:tblStyle',   { 'w:val' => 'DefaultTable' }
            xml.send 'w:bidiVisual', { 'w:val' => '0' }
            xml.send 'w:tblW',       { 'w:w'   => model.table_width.to_f, 'w:type' => 'dxa' }
            xml.send 'w:tblInd',     { 'w:w'   => '0.0', 'w:type' => 'dxa' }
            xml.send 'w:jc',         { 'w:val' => model.table_align }
            unless borders.empty?
              xml.send 'w:tblBorders' do
                borders.each do |m|
                  options = {
                    'w:color' => model.send("table_border_#{ m }_color"),
                    'w:val'   => model.send("table_border_#{ m }_line"),
                    'w:sz'    => model.send("table_border_#{ m }_size"),
                    'w:space' => model.send("table_border_#{ m }_spacing")
                  }
                  xml.send "w:#{ Caracal::Core::Models::BorderModel.formatted_type(m) }", options
                end
              end
            end
            xml.send 'w:tblLayout', { 'w:type' => 'fixed' }
            xml.send 'w:tblLook',   { 'w:val'  => '0600'  }
          end
          xml.send 'w:tblGrid' do
            model.rows.first.each do |tc|
              xml.send 'w:gridCol', { 'w:w' => tc.cell_width }
            end
            xml.send 'w:tblGridChange', { 'w:id' => '0' } do
              xml.send 'w:tblGrid' do
                model.rows.first.each do |tc|
                  xml.send 'w:gridCol', { 'w:w' => tc.cell_width }
                end
              end
            end
          end
          model.rows.each do |row|
            xml.send 'w:tr' do
              row.each do |tc|
                xml.send 'w:tc' do
                  xml.send 'tcPr' do
                    xml.send 'w:shd', { 'w:fill' => tc.cell_background }
                    xml.send 'w:vAlign', { 'w:val' => tc.cell_vertical_align }
                    xml.send 'w:tcMar' do
                      %w(top left bottom right).each do |d|
                        xml.send "w:#{ d }", { 'w:w' => tc.send("cell_margin_#{ d }").to_f, 'w:type' => 'dxa' }
                      end
                    end
                  end
                  tc.contents.each do |m|
                    method = render_method_for_model(m)
                    send(method, xml, m)
                  end
                end
              end
            end
          end
        end

        # don't know why this is needed, but it prevents a
        # rendering error.
        render_paragraph(xml, Caracal::Core::Models::ParagraphModel.new)
      end


      #============= OPTIONS ===================================

      def root_options
        {
          'xmlns:mc'   => 'http://schemas.openxmlformats.org/markup-compatibility/2006',
          'xmlns:o'    => 'urn:schemas-microsoft-com:office:office',
          'xmlns:r'    => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
          'xmlns:m'    => 'http://schemas.openxmlformats.org/officeDocument/2006/math',
          'xmlns:v'    => 'urn:schemas-microsoft-com:vml',
          'xmlns:wp'   => 'http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing',
          'xmlns:w10'  => 'urn:schemas-microsoft-com:office:word',
          'xmlns:w'    => 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
          'xmlns:wne'  => 'http://schemas.microsoft.com/office/word/2006/wordml',
          'xmlns:sl'   => 'http://schemas.openxmlformats.org/schemaLibrary/2006/main',
          'xmlns:a'    => 'http://schemas.openxmlformats.org/drawingml/2006/main',
          'xmlns:pic'  => 'http://schemas.openxmlformats.org/drawingml/2006/picture',
          'xmlns:c'    => 'http://schemas.openxmlformats.org/drawingml/2006/chart',
          'xmlns:lc'   => 'http://schemas.openxmlformats.org/drawingml/2006/lockedCanvas',
          'xmlns:dgm'  => 'http://schemas.openxmlformats.org/drawingml/2006/diagram'
        }
      end

      def page_margin_options
        {
          'w:top'    => document.page_margin_top,
          'w:bottom' => document.page_margin_bottom,
          'w:left'   => document.page_margin_left,
          'w:right'  => document.page_margin_right
        }
      end

      def page_size_options
        {
          'w:w' => document.page_width,
          'w:h' => document.page_height
        }
      end

    end
  end
end

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
      def render_run_attributes(xml, model)
        if model.respond_to? :run_attributes
          attrs = model.run_attributes.delete_if { |k, v| v.nil? } 
        
          unless attrs.empty?
            xml.send 'w:rPr' do
              xml.send 'w:rStyle', { 'w:val' => attrs[:style] }                            unless attrs[:style].nil?
              xml.send 'w:color',  { 'w:val' => attrs[:color] }                            unless attrs[:color].nil?
              xml.send 'w:sz',     { 'w:val' => attrs[:size]  }                            unless attrs[:size].nil?
              xml.send 'w:b',      { 'w:val' => (attrs[:bold] ? '1' : '0') }               unless attrs[:bold].nil?
              xml.send 'w:i',      { 'w:val' => (attrs[:italic] ? '1' : '0') }             unless attrs[:italic].nil?
              xml.send 'w:u',      { 'w:val' => (attrs[:underline] ? 'single' : 'none') }  unless attrs[:underline].nil?
              xml.send 'w:rtl',    { 'w:val' => '0' }
            end
          end
        end
      end
      
      
      #============= MODEL RENDERERS ===========================
      
      def render_link(xml, model)
        rel = document.relationship target: model.link_href, type: :link
        
        xml.send 'w:hyperlink', { 'r:id' => rel.formatted_id } do
          xml.send 'w:r', run_options do
            render_run_attributes(xml, model)
            xml.send 'w:t', { 'xml:space' => 'preserve' }, model.link_content
          end
        end
      end
      
      def render_paragraph(xml, model)
        run_props = [:color, :size, :bold, :italic, :underline].map { |m| model.send("paragraph_#{ m }") }.compact
        
        xml.send 'w:p', paragraph_options do
          xml.send 'w:pPr' do
            xml.send 'w:contextualSpacing', { 'w:val' => '0' }
            xml.send 'w:pStyle', { 'w:val' => model.paragraph_style } unless model.paragraph_style.nil?
            render_run_attributes(xml, model)
          end
          model.runs.each do |run|
            method = render_method_for_model(run)
            send(method, xml, run)
          end
        end 
      end
      
      def render_text(xml, model)
        xml.send 'w:r', run_options do
          render_run_attributes(xml, model)
          xml.send 'w:t', { 'xml:space' => 'preserve' }, model.text_content
        end
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
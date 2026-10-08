require 'zip'

require 'caracal/core/bookmarks'
require 'caracal/core/custom_properties'
require 'caracal/core/file_name'
require 'caracal/core/fonts'
require 'caracal/core/footer'
require 'caracal/core/header'
require 'caracal/core/iframes'
require 'caracal/core/ignorables'
require 'caracal/core/images'
require 'caracal/core/list_styles'
require 'caracal/core/lists'
require 'caracal/core/namespaces'
require 'caracal/core/page_breaks'
require 'caracal/core/page_numbers'
require 'caracal/core/page_settings'
require 'caracal/core/relationships'
require 'caracal/core/rules'
require 'caracal/core/styles'
require 'caracal/core/tables'
require 'caracal/core/text'

require 'caracal/renderers/app_renderer'
require 'caracal/renderers/content_types_renderer'
require 'caracal/renderers/core_renderer'
require 'caracal/renderers/custom_renderer'
require 'caracal/renderers/document_renderer'
require 'caracal/renderers/fonts_renderer'
require 'caracal/renderers/footer_renderer'
require 'caracal/renderers/header_renderer'
require 'caracal/renderers/numbering_renderer'
require 'caracal/renderers/package_relationships_renderer'
require 'caracal/renderers/relationships_renderer'
require 'caracal/renderers/settings_renderer'
require 'caracal/renderers/styles_renderer'


module Caracal
  class Document

    #------------------------------------------------------
    # Configuration
    #------------------------------------------------------

    # mixins (order is important)
    include Caracal::Core::CustomProperties
    include Caracal::Core::FileName
    include Caracal::Core::Ignorables
    include Caracal::Core::Namespaces
    include Caracal::Core::Relationships

    include Caracal::Core::Fonts
    include Caracal::Core::PageSettings
    include Caracal::Core::PageNumbers
    include Caracal::Core::Styles
    include Caracal::Core::ListStyles

    include Caracal::Core::Bookmarks
    include Caracal::Core::IFrames
    include Caracal::Core::Images
    include Caracal::Core::Lists
    include Caracal::Core::PageBreaks
    include Caracal::Core::Rules
    include Caracal::Core::Tables
    include Caracal::Core::Text

    include Caracal::Core::Footer
    include Caracal::Core::Header


    #------------------------------------------------------
    # Public Class Methods
    #------------------------------------------------------

    #============ OUTPUT ==================================

    # This method renders a new Word document and returns it as a
    # a string.
    #
    def self.render(f_name = nil, &block)
      docx   = new(f_name, &block)
      buffer = docx.render

      buffer.rewind
      buffer.sysread
    end

    # This method renders a new Word document and saves it to the
    # file system.
    #
    def self.save(f_name = nil, &block)
      docx   = new(f_name, &block)
      docx.save
      # buffer = docx.render
      #
      # File.open(docx.path, 'wb') { |f| f.write(buffer.string) }
    end



    #------------------------------------------------------
    # Public Instance Methods
    #------------------------------------------------------

    # This method instantiates a new word document.
    #
    def initialize(name = nil, &block)
      file_name(name)

      page_size
      page_margins top: 1440, bottom: 1440, left: 1440, right: 1440
      page_numbers

      [:font, :list_style, :namespace, :relationship, :style].each do |method|
        collection = self.class.send("default_#{ method }s")
        collection.each do |item|
          send(method, item)
        end
      end

      if block_given?
        (block.arity < 1) ? instance_eval(&block) : block[self]
      end
    end


    #============ GETTERS =================================

    # This method returns an array of models which constitute the
    # set of instructions for producing the document content.
    #
    def contents
      @contents ||= []
    end

    # A header or footer part to write: which kind it is, which pages it
    # covers ('default' or 'first'), the content to render, whether to
    # add the page number, and whether the section refers to it.
    #
    HeaderFooterPart = Struct.new(:kind, :type, :target, :model, :page_number, :referenced)

    # This method returns the header and footer parts the document needs.
    # footer1.xml is always written, as it always has been, but is only
    # referenced when it has something to show.
    #
    def header_footer_parts
      parts = []
      if header_content
        parts << HeaderFooterPart.new(:header, 'default', 'header1.xml', header_content, false, true)
      end
      shown = page_number_show || !footer_content.nil?
      parts << HeaderFooterPart.new(:footer, 'default', 'footer1.xml', footer_content, page_number_show || footer_content.nil?, shown)

      if title_page?
        # The first page uses only first-page parts, so fall back to the
        # default content for whichever one wasn't customized.
        first_header = first_header_content || header_content
        if first_header && first_header.valid?
          parts << HeaderFooterPart.new(:header, 'first', 'header2.xml', first_header, false, true)
        end

        first_footer = first_footer_content || footer_content
        first_footer = nil unless first_footer && first_footer.valid?
        first_number = page_number_show && page_number_first
        if first_footer || first_number
          parts << HeaderFooterPart.new(:footer, 'first', 'footer2.xml', first_footer, first_number, true)
        end
      end
      parts
    end

    # This method returns whether the first page has its own header and
    # footer (Word's "Different First Page").
    #
    def title_page?
      !first_header_content.nil? || !first_footer_content.nil? || (page_number_show && !page_number_first)
    end


    #============ RENDERING ===============================

    # This method renders the word document instance into
    # a string buffer. Order is important!
    #
    def render
      register_nested_iframes(contents)
      header_footer_parts.each do |part|
        relationship({ target: part.target, type: part.kind })
      end

      buffer = ::Zip::OutputStream.write_buffer do |zip|
        render_package_relationships(zip)
        render_content_types(zip)
        render_app(zip)
        render_core(zip)
        render_custom(zip)
        render_fonts(zip)
        render_headers_and_footers(zip)
        render_settings(zip)
        render_styles(zip)
        render_document(zip)
        render_relationships(zip)   # Must go here: Depends on document renderer
        render_media(zip)           # Must go here: Depends on document renderer
        render_numbering(zip)       # Must go here: Depends on document renderer
      end
    end


    #============ SAVING ==================================

    def save
      buffer = render

      File.open(path, 'wb') { |f| f.write(buffer.string) }
    end


    #------------------------------------------------------
    # Private Instance Methods
    #------------------------------------------------------
    private

    #============ PREPROCESSING ===========================

    # Iframes inside table cells can't register their namespaces
    # on the document when they're created, so collect them here.
    #
    def register_nested_iframes(models)
      models.each do |model|
        case model
        when Caracal::Core::Models::IFrameModel
          model.namespaces.each do |(prefix, href)|
            namespace({ prefix: prefix, href: href })
          end
          model.ignorables.each do |prefix|
            ignorable(prefix)
          end
        when Caracal::Core::Models::TableModel
          model.cells.each { |cell| register_nested_iframes(cell.contents) }
        end
      end
    end


    #============ RENDERERS ===============================

    # This method adds a part to the package. Giving rubyzip the size up
    # front stops rubyzip 3 from adding a zip64 extra field "just in case"
    # to every entry, which LibreOffice 7.4 and older can't read.
    #
    def write_entry(zip, name, content)
      content = content.to_s
      entry   = ::Zip::Entry.new('', name)
      entry.size = content.bytesize

      zip.put_next_entry(entry)
      zip.write(content)
    end

    def render_app(zip)
      content = ::Caracal::Renderers::AppRenderer.render(self)

      write_entry(zip, 'docProps/app.xml', content)
    end

    def render_content_types(zip)
      content = ::Caracal::Renderers::ContentTypesRenderer.render(self)

      write_entry(zip, '[Content_Types].xml', content)
    end

    def render_core(zip)
      content = ::Caracal::Renderers::CoreRenderer.render(self)

      write_entry(zip, 'docProps/core.xml', content)
    end

    def render_custom(zip)
      content = ::Caracal::Renderers::CustomRenderer.render(self)

      write_entry(zip, 'docProps/custom.xml', content)
    end

    def render_document(zip)
      content = ::Caracal::Renderers::DocumentRenderer.render(self)

      write_entry(zip, 'word/document.xml', content)
    end

    def render_fonts(zip)
      content = ::Caracal::Renderers::FontsRenderer.render(self)

      write_entry(zip, 'word/fontTable.xml', content)
    end

    def render_headers_and_footers(zip)
      header_footer_parts.each do |part|
        renderer = (part.kind == :header) ? ::Caracal::Renderers::HeaderRenderer : ::Caracal::Renderers::FooterRenderer
        content  = renderer.render(self, part.model, part.page_number)

        write_entry(zip, "word/#{ part.target }", content)

        # rendering collects the relationships, so write them straight away
        render_part_relationships(zip, part.target, part.model)
      end
    end

    def render_media(zip)
      images = relationships.select { |r| r.relationship_type == :image }
      images.each do |rel|
        if rel.relationship_data.to_s.size > 0
          content = rel.relationship_data
        else
          content = ::Caracal::Utilities.read_resource(rel.relationship_target)
        end

        write_entry(zip, "word/#{ rel.formatted_target }", content)
      end
    end

    def render_numbering(zip)
      content = ::Caracal::Renderers::NumberingRenderer.render(self)

      write_entry(zip, 'word/numbering.xml', content)
    end

    def render_package_relationships(zip)
      content = ::Caracal::Renderers::PackageRelationshipsRenderer.render(self)

      write_entry(zip, '_rels/.rels', content)
    end

    def render_relationships(zip)
      content = ::Caracal::Renderers::RelationshipsRenderer.render(self)

      write_entry(zip, 'word/_rels/document.xml.rels', content)
    end

    # Headers and footers resolve their images and links against their
    # own relationships part, not the document's.
    #
    def render_part_relationships(zip, part, model)
      return if model.nil? || model.relationships.empty?

      content = ::Caracal::Renderers::RelationshipsRenderer.render(self, model.relationships)

      write_entry(zip, "word/_rels/#{ part }.rels", content)
    end

    def render_settings(zip)
      content = ::Caracal::Renderers::SettingsRenderer.render(self)

      write_entry(zip, 'word/settings.xml', content)
    end

    def render_styles(zip)
      content = ::Caracal::Renderers::StylesRenderer.render(self)

      write_entry(zip, 'word/styles.xml', content)
    end

  end
end

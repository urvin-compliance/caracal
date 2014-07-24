module Caracal
  class Document
    
    #-------------------------------------------------------------
    # Configuration
    #-------------------------------------------------------------
    
    # accessors
    attr_reader :page_margin_left
    attr_reader :page_margin_right
    attr_reader :page_margin_top
    attr_reader :page_margin_bottom
    attr_reader :page_number_show
    attr_reader :page_number_align
    attr_reader :page_width
    attr_reader :page_height
    
    # mixins
    include Caracal::Core::FileName
    include Caracal::Core::PageSettings
    
    
    #-------------------------------------------------------------
    # Public Class Methods
    #-------------------------------------------------------------
    
    # This method renders a new Word document and returns it as a
    # a string.
    #
    def self.render(name = nil, &block)
      docx   = new(name, &block)
      buffer = docx.render
      
      buffer.rewind
      buffer.sysread
    end
    
    # This method renders a new Word document and saves it to the
    # file system.
    #
    def self.save(name = nil, &block)
      docx   = new(name, &block)
      buffer = docx.render
      
      File.open("./#{ name }", 'w') { |f| f.write(buffer.string) }
    end
    
    
    
    #-------------------------------------------------------------
    # Public Instance Methods
    #-------------------------------------------------------------
    
   # This method instantiates a new word document.
    #
    def initialize(name = nil, &block)
      file_name  name
      page_size
      page_margins
      # page_numbers DEFAULT_SETTINGS[:numbers]
      # page_size    DEFAULT_SETTINGS[:size]
      
      if block
        (block.arity < 1) ? instance_eval(&block) : block[self]
      end
    end
    
    
    #============ RENDERING =================================
    
    # This method renders the word document instance into 
    # a string buffer.
    #
    def render
      buffer = ::Zip::OutputStream.write_buffer do |zip|
        render_app(zip)
        render_core(zip)
        # render_relationships(zip)
        # render_settings(zip)
        # render_fonts(zip)
        # render_styles(zip)
        # render_numbering(zip)
        # render_footer(zip)
        # render_document(zip)
        # render_content_types(zip)
      end
    end


    #============ PAGE SETTINGS =================================
    
    
    
    # This method controls whether page numbers are displayed in the footer and, if so,
    # which alignment is used. Defaults to nil
    #
    #
    # def page_numbers(value)
    #   show  = !!value
    #   align = value.to_s.to_sym unless value.nil?
    #
    #   if show && ![:left, :center, :right].include?(value)
    #     raise Caracal::Errors::InvalidPageSetting, "page_numbers method only accepts nil, :left, :center, or :right."
    #   else
    #     @page_number_show  = show
    #     @page_number_align = align
    #   end
    # end
    
    
    
    
    #-------------------------------------------------------------
    # Private Instance Methods
    #-------------------------------------------------------------
    private
    
    #============ RENDERERS =====================================
    
    def render_app(zip)
      content = ::Caracal::Renderers::AppRenderer.render(self)
      
      zip.put_next_entry('docProps/app.xml')
      zip.write(content)
    end
    
    def render_core(zip)
      content = ::Caracal::Renderers::CoreRenderer.render(self)
      
      zip.put_next_entry('docProps/core.xml')
      zip.write(content)
    end
    
    def render_relationships; end
    def render_settings; end
    def render_fonts; end
    def render_styles; end
    def render_numbering; end
    def render_footer; end
    def render_document; end
    def render_content_types; end
        
  end
end
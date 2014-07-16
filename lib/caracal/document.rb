module Caracal
  class Document
    
    #-------------------------------------------------------------
    # Configuration
    #-------------------------------------------------------------
    
    # constants
    DEFAULT_SETTINGS = {
      name: 'caracal.docx',
      size: {
        width:    12240,  # 8.5in in twips
        height:   15840   # 11in in twips
      },
      margins: {
        left:     1440,   # 1in in twips
        right:    1440,   # 1in in twips
        top:      1440,   # 1in in twips
        bottom:   1440    # 1in in twips
      },
      numbers:    nil     # accepts nil, :left, :center, or :right
    }
    
    # accessors
    attr_reader :name
    attr_reader :page_margin_left
    attr_reader :page_margin_right
    attr_reader :page_margin_top
    attr_reader :page_margin_bottom
    attr_reader :page_number_show
    attr_reader :page_number_align
    attr_reader :page_width
    attr_reader :page_height
    
    
    
    #-------------------------------------------------------------
    # Public Methods
    #-------------------------------------------------------------
    
    # This method creates and renders a new word document.
    #
    def self.generate(name = nil, &block)
      docx = new(name, &block)
      docx.render
    end
    
    # This method instantiates a new word document.
    #
    def initialize(name = DEFAULT_SETTINGS[:name], &block)
      file_name    name
      page_margins DEFAULT_SETTINGS[:margins]
      page_numbers DEFAULT_SETTINGS[:numbers]
      page_size    DEFAULT_SETTINGS[:size]
      
      if block
        (block.arity < 1) ? instance_eval(&block) : block[self]
      end
    end
    
    # This method renders the word document instance.
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
      File.open("tmp/#{ name }", 'w') { |f| f.write(buffer.string) }
    end


    #-------------------------------------------------------------
    # Private Methods
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
    
    
    #============ PAGE SETTINGS =================================
    
    # This method controls the name of the output file. Defaults to the name of the library.
    #
    def file_name(value)
      v = value.to_s.strip
      unless v.blank?
        @name = v
      end
    end
    
    # This method controls the margin spacing for each page.  Defaults to 1in for all
    # dimensions.
    #
    def page_margins(opts = {})
      left   = opts[:left].to_i
      right  = opts[:right].to_i
      top    = opts[:top].to_i
      bottom = opts[:bottom].to_i
      
      if left < 0 || right < 0 || top < 0 || bottom < 0
        raise Caracal::Errors::InvalidPageSetting, "page_size method requires non-zero :width and :height options."
      else
        @page_margin_left   = left
        @page_margin_right  = right
        @page_margin_top    = top
        @page_margin_bottom = bottom
      end
    end
    
    # This method controls whether page numbers are displayed in the footer and, if so,
    # which alignment is used. Defaults to nil
    #
    #
    def page_numbers(value)
      show  = !!value
      align = value.to_s.to_sym unless value.nil?
      
      if show && ![:left, :center, :right].include?(value)
        raise Caracal::Errors::InvalidPageSetting, "page_numbers method only accepts nil, :left, :center, or :right."
      else
        @page_number_show  = show
        @page_number_align = align
      end
    end
    
    # This method controls the physical width and height of the printed page. Defaults 
    # to US standard A4 portrait size.
    #
    def page_size(opts = {})
      width  = opts[:width].to_i
      height = opts[:height].to_i
      
      if width > 0 && height > 0
        @page_width  = width
        @page_height = height
      else
        raise Caracal::Errors::InvalidPageSetting, "page_size method requires non-zero :width and :height options."
      end
    end
    
    
  end
end
module Caracal
  class Document
    
    #-------------------------------------------------------------
    # Configuration
    #-------------------------------------------------------------
    
    # mixins (order is important)
    include Caracal::Core::Relationships
    include Caracal::Core::FileName
    include Caracal::Core::PageSettings
    include Caracal::Core::PageNumbers
    
    
    #-------------------------------------------------------------
    # Public Class Methods
    #-------------------------------------------------------------
    
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
      buffer = docx.render
      
      File.open("./#{ docx.name }", 'w') { |f| f.write(buffer.string) }
    end
    
    
    
    #-------------------------------------------------------------
    # Public Instance Methods
    #-------------------------------------------------------------
    
   # This method instantiates a new word document.
    #
    def initialize(name = nil, &block)
      file_name(name)
      page_size 
      page_margins 
      page_numbers
      
      self.class.default_relationships.each do |r|
        register_relationship(r[:target], r[:type])
      end
               
      if block_given?
        (block.arity < 1) ? instance_eval(&block) : block[self]
      end
    end
    
    
    #============ RENDERING =================================
    
    # This method renders the word document instance into 
    # a string buffer.
    #
    def render
      buffer = ::Zip::OutputStream.write_buffer do |zip|
        render_content_types(zip)
        # render_relationships(zip)
        render_app(zip)
        render_core(zip)
        # render_fonts(zip)
        render_footer(zip)
        # render_numbering(zip)
        render_settings(zip)
        # render_styles(zip)
        render_document(zip)
      end
    end
    
    
    
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
    
    def render_content_types(zip)
      content = ::Caracal::Renderers::ContentTypesRenderer.render(self)
      
      zip.put_next_entry('[Content_Types].xml')
      zip.write(content)
    end
    
    def render_core(zip)
      content = ::Caracal::Renderers::CoreRenderer.render(self)
      
      zip.put_next_entry('docProps/core.xml')
      zip.write(content)
    end
    
    def render_document(zip)
      content = ::Caracal::Renderers::DocumentRenderer.render(self)
      
      zip.put_next_entry('word/document.xml')
      zip.write(content)
    end
    
    def render_fonts; end
    
    def render_footer(zip)
      content = ::Caracal::Renderers::FooterRenderer.render(self)
      
      zip.put_next_entry('word/footer1.xml')
      zip.write(content)
    end
    
    def render_numbering; end
    
    def render_relationships; end
    
    def render_settings(zip)
      content = ::Caracal::Renderers::SettingsRenderer.render(self)
      
      zip.put_next_entry('word/settings.xml')
      zip.write(content)
    end
    
    def render_styles; end
        
  end
end
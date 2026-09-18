require 'spec_helper'
require 'stringio'
require 'tempfile'

describe Caracal::Document do
  W_NS = { 'w' => 'http://schemas.openxmlformats.org/wordprocessingml/2006/main' }

  let(:png)  { 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=='.unpack1('m') }
  let(:jpeg) { "\xFF\xD8\xFF\xE0".b + 'rest of jpeg' }
  # the PNG plus bytes a text-mode read would mangle on Windows
  let(:image_bytes) { png + "\r\n\x1A\r\n".b }

  def parts(docx)
    result = {}
    Zip::File.open_buffer(StringIO.new(docx.render.string)) do |zip|
      zip.each { |e| result[e.name] = e.get_input_stream.read }
    end
    result
  end

  def strict_xml(str)
    Nokogiri::XML(str) { |config| config.strict }
  end


  #-------------------------------------------------------------
  # Control characters
  #-------------------------------------------------------------

  describe 'text containing characters XML does not allow' do
    let(:text) { "a\x01b\x0Bc\td" }

    it 'strips them from paragraphs, links and table cells' do
      text = self.text
      docx = described_class.new('test.docx')
      docx.p text
      docx.p { link text, 'https://www.example.com' }
      docx.table [[text]]

      xml = parts(docx)['word/document.xml']
      expect { strict_xml(xml) }.not_to raise_error
      expect(xml.scan("abc\td").size).to eq 3
    end

    it 'strips them from custom properties' do
      text = self.text
      docx = described_class.new('test.docx')
      docx.custom_property { |p| p.name 'note'; p.value text; p.type :text }

      expect { strict_xml(parts(docx)['docProps/custom.xml']) }.not_to raise_error
    end
  end


  #-------------------------------------------------------------
  # Image part names
  #-------------------------------------------------------------

  describe 'image part names' do
    it 'uses the type of the supplied data rather than the URL' do
      png, jpeg = self.png, self.jpeg
      docx = described_class.new('test.docx')
      docx.img('https://bucket.example.com/rails/blobs/abc123?signature=x', width: 10, height: 10) { |i| i.data png }
      docx.img('https://bucket.example.com/photo.png?signature=y',          width: 10, height: 10) { |i| i.data jpeg }

      media = parts(docx).keys.grep(%r{\Aword/media/})
      expect(media.map { |name| File.extname(name) }).to eq %w(.png .jpeg)
    end

    {
      'https://example.com/a/photo.JPG?x=1#frag' => 'jpg',
      'https://example.com/rails/blobs/abc'     => 'png',
      'https://example.com'                     => 'png',
      '/tmp/picture.gif'                        => 'gif',
      'Picture 1'                               => 'png'
    }.each do |target, ext|
      it "names a #{ target.inspect } target with .#{ ext } when no data is supplied" do
        rel = Caracal::Core::Models::RelationshipModel.new(id: 1, type: :image, target: target)
        expect(rel.formatted_target).to eq "media/image1.#{ ext }"
      end
    end

    it 'registers content types for bmp, tiff and svg' do
      xml = parts(described_class.new('test.docx'))['[Content_Types].xml']
      %w(bmp tif tiff svg).each { |ext| expect(xml).to include %(Extension="#{ ext }") }
    end
  end


  #-------------------------------------------------------------
  # Image sources
  #-------------------------------------------------------------

  describe 'image sources' do
    def media(docx)
      parts(docx).select { |name, _| name.start_with?('word/media/') }.values
    end

    it 'embeds a local image byte-for-byte' do
      file = Tempfile.new(['image', '.png'])
      file.binmode
      file.write(image_bytes)
      file.close

      docx = described_class.new('test.docx')
      docx.img file.path, width: 10, height: 10

      expect(media(docx)).to eq [image_bytes]
    end

    it 'fetches an http(s) image via URI.open' do
      url = 'https://www.example.com/image.png'
      bytes = image_bytes
      expect(URI).to receive(:open).with(url, 'rb') { |*_, &blk| blk.call(StringIO.new(bytes)) }

      docx = described_class.new('test.docx')
      docx.img url, width: 10, height: 10

      expect(media(docx)).to eq [bytes]
    end

    it 'does not run a "|" target as a shell command' do
      marker = File.join(Dir.tmpdir, "caracal-pipe-#{ Process.pid }")
      docx   = described_class.new('test.docx')
      docx.img "|touch #{ marker }", width: 10, height: 10

      expect { docx.render }.to raise_error(Errno::ENOENT)
      expect(File.exist?(marker)).to eq false
    end
  end


  #-------------------------------------------------------------
  # Table column widths
  #-------------------------------------------------------------

  describe 'table grid column widths' do
    let(:data) do
      [
        [{ content: 'First', width: 2400 }, { content: 'Second', width: 1200 }],
        [{ content: 'Third', width: 1800 }, { content: 'Fourth', width: 1800 }]
      ]
    end

    it 'uses explicit column widths when set' do
      docx = described_class.new('test.docx')
      docx.table(data) { column_widths [1000, 2600] }

      xml = strict_xml(parts(docx)['word/document.xml'])
      expect(xml.xpath('//w:tbl/w:tblGrid/w:gridCol/@w:w', W_NS).map(&:value)).to eq %w(1000 2600)
    end

    it 'falls back to the first row widths otherwise' do
      docx = described_class.new('test.docx')
      docx.table(data)

      xml = strict_xml(parts(docx)['word/document.xml'])
      expect(xml.xpath('//w:tbl/w:tblGrid/w:gridCol/@w:w', W_NS).map(&:value)).to eq %w(2400 1200)
    end
  end


  #-------------------------------------------------------------
  # Iframes
  #-------------------------------------------------------------

  describe 'iframes' do
    let(:snippet) do
      inner = described_class.new('inner.docx')
      inner.p 'Text from the iframe'
      inner.render.string
    end

    it 'renders an iframe at the top level' do
      docx = described_class.new('test.docx')
      docx.iframe data: snippet

      xml = strict_xml(parts(docx)['word/document.xml'])
      expect(xml.at_xpath('//w:body/w:p/w:r/w:t[.="Text from the iframe"]', W_NS)).not_to be_nil
    end

    it 'renders an iframe inside a table cell' do
      data = snippet
      cell = Caracal::Core::Models::TableCellModel.new { |c| c.iframe(data: data) }
      docx = described_class.new('test.docx')
      docx.table [[cell]]

      xml = strict_xml(parts(docx)['word/document.xml'])
      expect(xml.at_xpath('//w:tc//w:t[.="Text from the iframe"]', W_NS)).not_to be_nil
    end

    it 'uses the data when the url is explicitly nil' do
      docx = described_class.new('test.docx')
      docx.iframe url: nil, data: snippet

      xml = strict_xml(parts(docx)['word/document.xml'])
      expect(xml.at_xpath('//w:body/w:p/w:r/w:t[.="Text from the iframe"]', W_NS)).not_to be_nil
    end

    it 'renders an iframe fetched from a URL' do
      url  = 'https://www.example.com/snippet.docx'
      data = snippet
      expect(URI).to receive(:open).with(url, 'rb') { |*_, &blk| blk.call(StringIO.new(data)) }

      docx = described_class.new('test.docx')
      docx.iframe url: url

      xml = strict_xml(parts(docx)['word/document.xml'])
      expect(xml.at_xpath('//w:body/w:p/w:r/w:t[.="Text from the iframe"]', W_NS)).not_to be_nil
    end
  end


  #-------------------------------------------------------------
  # Embedded document size limits
  #-------------------------------------------------------------

  describe 'embedded document entry size limit' do
    let(:model) { Caracal::Core::Models::IFrameModel }

    # rels is small enough to pass; document.xml is deliberately not
    let(:oversized) do
      Zip::OutputStream.write_buffer do |zip|
        zip.put_next_entry('word/_rels/document.xml.rels')
        zip.write '<?xml version="1.0"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"></Relationships>'
        zip.put_next_entry('word/document.xml')
        zip.write '<?xml version="1.0"?><w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body>' + ('<!-- padding -->' * 200) + '<w:sectPr/></w:body></w:document>'
      end.string
    end

    around do |example|
      previous = model.max_entry_size
      model.max_entry_size = 1024
      example.run
      model.max_entry_size = previous
    end

    it 'defaults to 50MB' do
      expect(model::DEFAULT_MAX_ENTRY_SIZE).to eq 50 * 1024 * 1024
    end

    it 'refuses an entry larger than the limit' do
      docx = described_class.new('test.docx')

      expect { docx.iframe data: oversized }.to raise_error(Caracal::Errors::InvalidModelError, /over the 1024 byte limit/)
    end
  end
end

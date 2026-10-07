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
  # Zip container
  #-------------------------------------------------------------

  describe 'the zip container' do
    let(:bytes) do
      png  = self.png
      docx = described_class.new('test.docx') do
        p 'hello'
        img 'logo.png', data: png, width: 10, height: 10
      end
      docx.render.string.b
    end

    # LibreOffice 7.4 and older refuse to open a package whose entries
    # carry zip64 extra fields, which rubyzip 3 adds when it doesn't know
    # an entry's size in advance.
    it 'writes no zip64 records' do
      offsets = []
      bytes.scan("PK\x03\x04".b) { offsets << $~.begin(0) }
      versions = offsets.map { |o| bytes[o + 4, 2].unpack1('v') }
      extras   = offsets.map do |o|
        name_len, extra_len = bytes[o + 26, 4].unpack('vv')
        bytes[o + 30 + name_len, extra_len]
      end

      expect(offsets).not_to be_empty
      expect(versions).to all(be < 45)
      expect(extras.map { |e| e.unpack('v*').each_slice(2).map(&:first) }.flatten).not_to include(0x0001)
      expect(bytes).not_to include("PK\x06\x06".b)
    end

    it 'still produces a readable package' do
      names = []
      Zip::File.open_buffer(StringIO.new(bytes)) { |zip| zip.each { |e| names << e.name } }

      expect(names).to include('word/document.xml', '[Content_Types].xml')
      expect(names.grep(%r{\Aword/media/}).size).to eq 1
    end
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


  #-------------------------------------------------------------
  # Page number field
  #-------------------------------------------------------------

  describe 'the page number field' do
    let(:footer) do
      docx = described_class.new('test.docx')
      docx.page_numbers true
      strict_xml(parts(docx)['word/footer1.xml'])
    end

    it 'emits begin, separate and end field characters' do
      types = footer.xpath('//w:fldChar/@w:fldCharType', W_NS).map(&:value)

      expect(types).to eq %w(begin separate end)
    end

    it 'carries PAGE as the field instruction' do
      expect(footer.at_xpath('//w:instrText', W_NS).text.strip).to eq 'PAGE'
    end

    it 'spreads the field across separate runs rather than packing one' do
      field_runs = footer.xpath('//w:ftr/w:p/w:r', W_NS).select do |run|
        run.at_xpath('w:fldChar', W_NS) || run.at_xpath('w:instrText', W_NS)
      end

      expect(field_runs.size).to eq 4
    end
  end


  #-------------------------------------------------------------
  # Nested lists
  #-------------------------------------------------------------

  describe 'nested lists' do
    def paragraphs(docx)
      strict_xml(parts(docx)['word/document.xml']).xpath('//w:body/w:p', W_NS).map do |p|
        level = p.at_xpath('w:pPr/w:numPr/w:ilvl/@w:val', W_NS)
        [p.xpath('.//w:t', W_NS).map(&:text).join, level && level.value.to_i]
      end
    end

    # #87
    it 'renders text added after a nested list after it' do
      docx = described_class.new('test.docx') do
        ul do
          li do
            ol do
              li 'First'
            end
            text 'Second'
          end
        end
      end

      expect(paragraphs(docx)).to eq [['', 0], ['First', 1], ['Second', nil]]
    end

    it 'indents the continuation with the item text' do
      docx = described_class.new('test.docx') do
        ul do
          li 'Intro' do
            ul { li 'Nested' }
            text 'Outro'
          end
        end
      end
      xml   = strict_xml(parts(docx)['word/document.xml'])
      intro = xml.at_xpath('//w:body/w:p[1]/w:pPr/w:ind', W_NS)
      outro = xml.at_xpath('//w:body/w:p[3]/w:pPr/w:ind', W_NS)

      expect(outro['w:left']).to eq intro['w:left']
      expect(outro['w:hanging']).to be_nil
    end

    it 'keeps every nested list in an item, in order' do
      docx = described_class.new('test.docx') do
        ol do
          li 'Item' do
            ol { li 'A' }
            text 'between'
            ul { li 'B' }
          end
          li 'Next'
        end
      end

      expect(paragraphs(docx)).to eq [['Item', 0], ['A', 1], ['between', nil], ['B', 1], ['Next', 0]]
    end

    it 'renders a nested list that ends the item as before' do
      docx = described_class.new('test.docx') do
        ol do
          li 'First' do
            ol { li 'Sub 1'; li 'Sub 2' }
          end
          li 'Second'
        end
      end

      expect(paragraphs(docx)).to eq [['First', 0], ['Sub 1', 1], ['Sub 2', 1], ['Second', 0]]
    end
  end


  #-------------------------------------------------------------
  # Headers and footers
  #-------------------------------------------------------------

  describe 'headers and footers' do
    R_NS   = { 'r' => 'http://schemas.openxmlformats.org/package/2006/relationships' }
    CT_NS  = { 'ct' => 'http://schemas.openxmlformats.org/package/2006/content-types' }

    def section(files)
      strict_xml(files['word/document.xml']).at_xpath('//w:body/w:sectPr', W_NS)
    end

    def rels(files, part)
      strict_xml(files["word/_rels/#{ part }.rels"]).xpath('//r:Relationship', R_NS)
    end

    # Every relationship of every part must resolve to a part in the package,
    # and every XML part must be well formed. Word refuses to open the file
    # otherwise.
    def expect_consistent_package(files)
      files.each do |name, content|
        next unless name.end_with?('.xml', '.rels')
        expect { strict_xml(content) }.not_to raise_error, name
      end
      files.keys.grep(%r{\Aword/_rels/.+\.rels\z}).each do |name|
        strict_xml(files[name]).xpath('//r:Relationship', R_NS).each do |rel|
          next if rel['TargetMode'] == 'External'
          expect(files).to have_key("word/#{ rel['Target'] }"), "#{ name } -> #{ rel['Target'] }"
        end
      end
    end

    describe 'a document without a header' do
      let(:files) { parts(described_class.new('test.docx') { p 'body' }) }

      it 'writes no header part and refers to none' do
        expect(files).not_to have_key('word/header1.xml')
        expect(section(files).at_xpath('w:headerReference', W_NS)).to be_nil
        expect(files['[Content_Types].xml']).not_to include('header1.xml')
        expect(files['word/_rels/document.xml.rels']).not_to include('header1.xml')
        expect_consistent_package(files)
      end
    end

    describe 'a document with a header and no page numbers' do
      let(:files) do
        parts(described_class.new('test.docx') do
          header { p 'hello there' }
          p 'body'
        end)
      end

      it 'writes the header and refers to it from the section' do
        hdr = strict_xml(files['word/header1.xml'])
        ref = section(files).at_xpath('w:headerReference', W_NS)
        rel = rels(files, 'document.xml').find { |r| r['Target'] == 'header1.xml' }

        expect(hdr.at_xpath('/w:hdr/w:p//w:t', W_NS).text).to eq 'hello there'
        expect(ref['r:id']).to eq rel['Id']
        expect(files['[Content_Types].xml']).to include('/word/header1.xml')
        expect_consistent_package(files)
      end

      it 'does not refer to the unused footer' do
        expect(section(files).at_xpath('w:footerReference', W_NS)).to be_nil
      end
    end

    describe 'a footer with page and page count fields' do
      let(:files) do
        parts(described_class.new('test.docx') do
          footer do
            p do
              text 'Page '
              field :page, bold: true
              text ' of '
              field :numpages
            end
          end
        end)
      end
      let(:ftr) { strict_xml(files['word/footer1.xml']) }

      it 'renders each field as begin, instruction, separate and end runs' do
        runs     = ftr.xpath('/w:ftr/w:p/w:r', W_NS)
        sequence = runs.map do |r|
          (c = r.at_xpath('w:fldChar', W_NS)) ? c['w:fldCharType'] : r.at_xpath('w:instrText|w:t', W_NS).text
        end

        # a paragraph built from a block starts with an empty text run
        expect(sequence.reject(&:empty?)).to eq ['Page ', 'begin', ' PAGE ', 'separate', 'end', ' of ', 'begin', ' NUMPAGES ', 'separate', 'end']
        expect(ftr.xpath('//w:p/w:fldChar', W_NS)).to be_empty
      end

      it 'applies the run formatting to every run of the field' do
        bold = ftr.xpath('/w:ftr/w:p/w:r[w:rPr/w:b[@w:val="1"]]', W_NS)

        expect(bold.size).to eq 4
      end

      it 'refers to the footer from the section' do
        expect(section(files).at_xpath('w:footerReference', W_NS)).not_to be_nil
        expect_consistent_package(files)
      end
    end

    describe 'a footer combined with page numbers' do
      let(:ftr) do
        docx = described_class.new('test.docx') do
          footer { p 'Confidential' }
          page_numbers true, label: 'Page'
        end
        strict_xml(parts(docx)['word/footer1.xml'])
      end

      it 'renders the footer content above the page number' do
        paragraphs = ftr.xpath('/w:ftr/w:p', W_NS)

        expect(paragraphs.size).to eq 2
        expect(paragraphs[0].text).to eq 'Confidential'
        expect(paragraphs[1].at_xpath('.//w:instrText', W_NS).text.strip).to eq 'PAGE'
      end
    end

    describe 'images and links in a header or footer' do
      let(:files) do
        png = self.png
        parts(described_class.new('test.docx') do
          header { img 'logo.png', data: png, width: 10, height: 10 }
          footer { p { link 'example', 'https://www.example.com' } }
          img 'other.png', data: png + 'x', width: 10, height: 10
        end)
      end

      it 'resolves the header image through the header relationships' do
        embed = strict_xml(files['word/header1.xml']).at_xpath('//a:blip/@r:embed', W_NS.merge(
          'a' => 'http://schemas.openxmlformats.org/drawingml/2006/main',
          'r' => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'
        )).value
        rel = rels(files, 'header1.xml').find { |r| r['Id'] == embed }

        expect(rel['Target']).to match(%r{\Amedia/image\d+\.png\z})
        expect(files["word/#{ rel['Target'] }"]).to eq png
      end

      it 'gives the header and body images distinct media parts' do
        media = files.keys.grep(%r{\Aword/media/})

        expect(media.size).to eq 2
      end

      it 'resolves the footer link through the footer relationships' do
        id  = strict_xml(files['word/footer1.xml']).at_xpath('//w:hyperlink', W_NS)['r:id']
        rel = rels(files, 'footer1.xml').find { |r| r['Id'] == id }

        expect(rel['Target']).to eq 'https://www.example.com'
        expect(rel['TargetMode']).to eq 'External'
      end

      it 'produces a consistent package' do
        expect_consistent_package(files)
      end
    end
  end
end

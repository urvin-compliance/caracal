require 'spec_helper'

describe Caracal::Core::Models::ParagraphModel do
  subject do
    described_class.new content: 'Lorem ipsum dolor....' do
      style       'Fancy'
      align       :right
      color       '666666'
      size        20
      bold        false
      italic      false
      underline   true
      bgcolor     'cccccc'
    end
  end


  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do

    # accessors
    describe 'accessors' do
      it { expect(subject.paragraph_style).to eq 'Fancy' }
      it { expect(subject.paragraph_align).to eq :right }
      it { expect(subject.paragraph_color).to eq '666666' }
      it { expect(subject.paragraph_size).to eq 20 }
      it { expect(subject.paragraph_bold).to eq false }
      it { expect(subject.paragraph_italic).to eq false }
      it { expect(subject.paragraph_underline).to eq true }
      it { expect(subject.paragraph_bgcolor).to eq 'cccccc' }
    end

  end


  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    #=============== GETTERS ==========================

    # .runs
    describe '.runs' do
      it { expect(subject.runs).to be_a(Array) }
    end

    # .run_attributes
    describe '.run_attributes' do
      let(:expected) { { color: '666666', size: 20, bold: false, italic: false, underline: true, bgcolor: 'cccccc' } }

      it { expect(subject.run_attributes).to eq expected }
    end


    #=============== SETTERS ==========================

    # booleans
    describe '.bold' do
      before { subject.bold(true) }

      it { expect(subject.paragraph_bold).to eq true }
    end
    describe '.italic' do
      before { subject.italic(true) }

      it { expect(subject.paragraph_italic).to eq true }
    end
    describe '.underline' do
      before { subject.underline(true) }

      it { expect(subject.paragraph_underline).to eq true }
    end

    # integers
    describe '.size' do
      before { subject.size(24) }

      it { expect(subject.paragraph_size).to eq 24 }
    end

    # strings
    describe '.bgcolor' do
      before { subject.bgcolor('dddddd') }

      it { expect(subject.paragraph_bgcolor).to eq 'dddddd' }
    end
    describe '.color' do
      before { subject.color('999999') }

      it { expect(subject.paragraph_color).to eq '999999' }
    end
    describe '.style' do
      before { subject.style('Dummy') }

      it { expect(subject.paragraph_style).to eq 'Dummy' }
    end

    # symbols
    describe '.align' do
      before { subject.align(:center) }

      it { expect(subject.paragraph_align).to eq :center }
    end


    #=============== SUB-METHODS ==========================

    # .link
    describe '.link' do
      let!(:length) { subject.runs.length }

      before { subject.link 'Text', 'http://www.google.com' }

      it { expect(subject.runs.size).to eq length + 1 }
    end

    # .br
    describe '.br' do
      let!(:length) { subject.runs.length }

      before { subject.br }

      it { expect(subject.runs.size).to eq length + 1 }
    end

    # .text
    describe '.text' do
      let!(:length) { subject.runs.length }

      before { subject.text 'Text' }

      it { expect(subject.runs.size).to eq length + 1 }
    end

    # .field
    describe '.field' do
      let!(:length) { subject.runs.length }

      context ':page' do
        before { subject.field :page }

        it { expect(subject.runs.size).to eq length + 1 }
      end

      context ':numpages' do
        before { subject.field :numpages }

        it { expect(subject.runs.size).to eq length + 1 }
      end
    end

    # .bookmark
    describe '.bookmark_start' do
      let!(:length) { subject.runs.length }

      before { subject.bookmark_start(id:'1', name:'abc')}

      it { expect(subject.runs.size).to eq length + 1 }
    end

    describe '.bookmark_end' do
      let!(:length) { subject.runs.length }

      before { subject.bookmark_end(id:'1')}

      it { expect(subject.runs.size).to eq length + 1 }
    end


    #=============== VALIDATION ===========================

    describe '.valid?' do
      describe 'when at least one run exists' do
        before do
          allow(subject).to receive(:runs).and_return(['a'])
        end

        it { expect(subject.valid?).to eq true }
      end
      describe 'when no runs exist' do
        before do
          allow(subject).to receive(:runs).and_return([])
        end

        it { expect(subject.valid?).to eq false }
      end
    end

  end


  #-------------------------------------------------------------
  # Private Methods
  #-------------------------------------------------------------

  describe 'private method tests' do

    # .option_keys
    describe '.option_keys' do
      let(:actual)   { subject.send(:option_keys).sort }
      let(:expected) { [:content, :style, :align, :color, :size, :bold, :italic, :underline, :bgcolor].sort }

      it { expect(actual).to eq expected }
    end

  end

end

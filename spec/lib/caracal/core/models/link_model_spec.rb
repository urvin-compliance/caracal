require 'spec_helper'

describe Caracal::Core::Models::LinkModel do
  subject do
    described_class.new do
      content     'Link Text'
      href        'http://www.google.com'
      font        'Courier New'
      color       '666666'
      size        20
      bold        false
      italic      false
      underline   true
    end
  end

  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do

    # constants
    describe 'constants' do
      it { expect(described_class::DEFAULT_LINK_COLOR).to     eq '1155cc' }
      it { expect(described_class::DEFAULT_LINK_UNDERLINE).to eq true }
    end

    # accessors
    describe 'accessors' do
      it { expect(subject.link_content).to eq 'Link Text' }
      it { expect(subject.link_href).to eq 'http://www.google.com' }
      it { expect(subject.link_font).to eq 'Courier New' }
      it { expect(subject.link_color).to eq '666666' }
      it { expect(subject.link_size).to eq 20 }
      it { expect(subject.link_bold).to eq false }
      it { expect(subject.link_italic).to eq false }
      it { expect(subject.link_underline).to eq true }
    end

  end


  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    #=============== GETTERS ==========================

    # .run_attributes
    describe '.run_attributes' do
      let(:expected) { { font: 'Courier New', color: '666666', size: 20, bold: false, italic: false, underline: true } }

      it { expect(subject.run_attributes).to eq expected }
    end


    #=============== SETTERS ==========================

    # booleans
    describe '.bold' do
      before { subject.bold(true) }

      it { expect(subject.link_bold).to eq true }
    end
    describe '.italic' do
      before { subject.italic(true) }

      it { expect(subject.link_italic).to eq true }
    end
    describe '.underline' do
      before { subject.underline(true) }

      it { expect(subject.link_underline).to eq true }
    end

    # integers
    describe '.size' do
      before { subject.size(24) }

      it { expect(subject.link_size).to eq 24 }
    end

    # strings
    describe '.color' do
      before { subject.color('999999') }

      it { expect(subject.link_color).to eq '999999' }
    end
    describe '.content' do
      before { subject.content('Something Else') }

      it { expect(subject.link_content).to eq 'Something Else' }
    end
    describe '.href' do
      before { subject.href('http://www.google.com') }

      it { expect(subject.link_href).to eq 'http://www.google.com' }
    end
    describe '.font' do
      before { subject.font('Palantino') }

      it { expect(subject.link_font).to eq 'Palantino' }
    end


    #=============== VALIDATION ===========================

    describe '.valid?' do
      describe 'when required attributes provided' do
        it { expect(subject.valid?).to eq true }
      end
      [:content, :href].each do |prop|
        describe "when #{ prop } nil" do
          before do
            allow(subject).to receive("link_#{ prop }").and_return(nil)
          end

          it { expect(subject.valid?).to eq false }
        end
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
      let(:expected) { [:content, :href, :font, :color, :size, :bold, :italic, :underline].sort }

      it { expect(actual).to eq expected }
    end

  end

end

require 'spec_helper'

describe Caracal::Core::Models::TextModel do
  subject do
    described_class.new do
      content         'Lorem ipsum dolor....'
      font            'Courier New'
      color           '666666'
      size            20
      bold            false
      italic          false
      underline       true
      bgcolor         'cccccc'
      vertical_align  :subscript
      highlight_color 'yellow'
    end
  end

  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do

    # accessors
    describe 'accessors' do
      it { expect(subject.text_content).to eq 'Lorem ipsum dolor....' }
      it { expect(subject.text_font).to eq 'Courier New' }
      it { expect(subject.text_color).to eq '666666' }
      it { expect(subject.text_size).to eq 20 }
      it { expect(subject.text_bold).to eq false }
      it { expect(subject.text_italic).to eq false }
      it { expect(subject.text_underline).to eq true }
      it { expect(subject.text_bgcolor).to eq 'cccccc' }
      it { expect(subject.text_highlight_color).to eq 'yellow' }
      it { expect(subject.text_vertical_align).to eq :subscript }
    end

  end


  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    #=============== GETTERS ==========================

    # .run_attributes
    describe '.run_attributes' do
      let(:expected) { { style: nil, font: 'Courier New', color: '666666', size: 20, bold: false, italic: false, underline: true, bgcolor: 'cccccc', highlight_color: 'yellow', vertical_align: :subscript } }

      it { expect(subject.run_attributes).to eq expected }
    end


    #=============== SETTERS ==========================

    # booleans
    describe '.bold' do
      before { subject.bold(true) }

      it { expect(subject.text_bold).to eq true }
    end
    describe '.italic' do
      before { subject.italic(true) }

      it { expect(subject.text_italic).to eq true }
    end
    describe '.underline' do
      before { subject.underline(true) }

      it { expect(subject.text_underline).to eq true }
    end

    # integers
    describe '.size' do
      before { subject.size(24) }

      it { expect(subject.text_size).to eq 24 }
    end

    # strings
    describe '.bgcolor' do
      before { subject.bgcolor('dddddd') }

      it { expect(subject.text_bgcolor).to eq 'dddddd' }
    end
    describe '.color' do
      before { subject.color('999999') }

      it { expect(subject.text_color).to eq '999999' }
    end
    describe '.hightlight_color' do
      before { subject.highlight_color('green') }

      it { expect(subject.text_highlight_color).to eq 'green' }
    end
    describe '.content' do
      before { subject.content('Something Else') }

      it { expect(subject.text_content).to eq 'Something Else' }
    end
    describe '.font' do
      before { subject.font('Palantino') }

      it { expect(subject.text_font).to eq 'Palantino' }
    end

    #symbols
    describe '.vertical_align' do
      before { subject.vertical_align(:superscript) }

      it { expect(subject.text_vertical_align).to eq :superscript }
    end

    #=============== VALIDATION ===========================

    describe '.valid?' do
      describe 'when required attributes provided' do
        it { expect(subject.valid?).to eq true }
      end
      [:content].each do |prop|
        describe "when #{ prop } nil" do
          before do
            allow(subject).to receive("text_#{ prop }").and_return(nil)
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
      let(:expected) { [:bgcolor, :bold, :color, :content, :font, :highlight_color, :italic, :size, :style, :underline, :vertical_align].sort }

      it { expect(actual).to eq expected }
    end

  end

end

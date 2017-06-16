require 'spec_helper'

describe Caracal::Core::Models::IFrameModel do
  subject do
    described_class.new do
      url    'https://www.example.com/snippet.docx'
    end
  end



  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do

    # accessors
    describe 'accessors' do
      it { expect(subject.iframe_url).to    eq 'https://www.example.com/snippet.docx' }
    end

  end


  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    #=============== SETTERS ==========================

    # .url
    describe '.url' do
      before { subject.url('https://www.example.com/sample.docx') }

      it { expect(subject.iframe_url).to eq 'https://www.example.com/sample.docx' }
    end

    # .data
    describe '.data' do
      before { subject.data('DOCX data follows here') }

      it { expect(subject.iframe_data).to eq 'DOCX data follows here' }
    end


    #=============== VALIDATION ===========================

    describe '.valid?' do
      describe 'when either value present' do
        it { expect(subject.valid?).to eq true }
      end
      describe 'when neither value present' do
        before do
          subject.url(nil)
          subject.data(nil)
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
      let(:expected) { [:url, :data].sort }

      it { expect(actual).to eq expected }
    end

  end

end

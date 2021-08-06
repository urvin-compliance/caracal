require 'spec_helper'

describe Caracal::Core::Images do
  subject { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    # .img
    describe '.img' do
      let!(:size) { subject.contents.size }
      let!(:url) { 'https://www.google.com/images/srpr/logo11w.png' }

      describe 'when no data provided' do
        before { subject.img url, width: 538, height: 190 }

        it { expect(subject.contents.size).to eq size + 1 }
        it { expect(subject.contents.last).to be_a(Caracal::Core::Models::ImageModel) }
      end

      describe 'when data provided as binary' do
        let!(:binary_data) { open(url).read }

        before { subject.img url, data: binary_data, width: 538, height: 190 }

        it { expect(subject.contents.size).to eq size + 1 }
        it { expect(subject.contents.last).to be_a(Caracal::Core::Models::ImageModel) }
        it { expect(subject.contents.last.image_data).to eq binary_data }
      end
    end
    
  end
  
end
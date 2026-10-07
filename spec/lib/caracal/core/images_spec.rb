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
      
      before { subject.img 'https://www.google.com/images/srpr/logo11w.png', width: 538, height: 190 }
      
      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::ImageModel) }

      describe 'when data and ppi are passed as options' do
        before { subject.img 'logo.png', data: 'PNG Data follows here', ppi: 96, width: 538, height: 190 }

        it { expect(subject.contents.last.image_data).to eq 'PNG Data follows here' }
        it { expect(subject.contents.last.image_ppi).to eq 96 }
      end
    end
    
  end
  
end
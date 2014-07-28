require 'spec_helper'

describe Caracal::Core::Models::PageSizeModel do
  subject do 
    described_class.new do
      width  15840
      height 12240
    end
  end
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # accessors
    describe 'accessors' do
      it { expect(subject.page_width).to eq 15840 }
      it { expect(subject.page_height).to eq 12240 }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
    
    # .width
    describe '.width' do
      before { subject.width(10000) }
      
      it { expect(subject.page_width).to eq 10000 }
    end
    
    # .height
    describe '.height' do
      before { subject.height(10000) }
      
      it { expect(subject.page_height).to eq 10000 }
    end
    
    # .to_options
    describe '.to_options' do
      let(:actual)   { subject.to_options }
      let(:expected) { { width: 15840, height: 12240 } }
      
      it { expect(actual).to eq expected}
    end
  
  end
  
end
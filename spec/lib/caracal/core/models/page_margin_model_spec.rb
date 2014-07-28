require 'spec_helper'

describe Caracal::Core::Models::PageMarginModel do
  subject do 
    described_class.new do
      top     1441
      bottom  1442
      left    1443
      right   1444
    end
  end
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # accessors
    describe 'accessors' do
      it { expect(subject.page_margin_top).to     eq 1441 }
      it { expect(subject.page_margin_bottom).to  eq 1442 }
      it { expect(subject.page_margin_left).to    eq 1443 }
      it { expect(subject.page_margin_right).to   eq 1444 }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
  
    # .top
    describe '.top' do
      before { subject.top(1000) }
      
      it { expect(subject.page_margin_top).to eq 1000 }
    end
    
    # .bottom
    describe '.bottom' do
      before { subject.bottom(1000) }
      
      it { expect(subject.page_margin_bottom).to eq 1000 }
    end
    
    # .left
    describe '.left' do
      before { subject.left(1000) }
      
      it { expect(subject.page_margin_left).to eq 1000 }
    end
    
    # .right
    describe '.right' do
      before { subject.right(1000) }
      
      it { expect(subject.page_margin_right).to eq 1000 }
    end
    
    # .to_options
    describe '.to_options' do
      let(:actual)   { subject.to_options }
      let(:expected) { { top: 1441, bottom: 1442, left: 1443, right: 1444 } }
      
      it { expect(actual).to eq expected}
    end
  
  end
  
end
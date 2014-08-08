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
    
    # constants
    describe 'constants' do
      it { expect(described_class::DEFAULT_PAGE_WIDTH).to eq 12240 }
      it { expect(described_class::DEFAULT_PAGE_HEIGHT).to eq 15840 }
    end
    
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
    
    #=============== SETTERS ==========================
    
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
    
    
    #=============== VALIDATION ===========================
    
    describe '.valid?' do
      describe 'when all sizes gt 0' do
        it { expect(subject.valid?).to eq true }
      end
      [:width, :height].each do |d|
        describe "when #{ d } lte 0" do
          before do
            allow(subject).to receive("page_#{ d }").and_return(0)
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
      let(:expected) { [:width, :height].sort }
      
      it { expect(actual).to eq expected }
    end
    
  end
  
end
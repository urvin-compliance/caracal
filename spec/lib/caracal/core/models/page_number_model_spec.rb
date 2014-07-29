require 'spec_helper'

describe Caracal::Core::Models::PageNumberModel do
  subject do 
    described_class.new do
      show  true
      align :right
    end
  end
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # constants
    describe 'constants' do
      it { expect(described_class::DEFAULT_PAGE_NUMBER_ALIGN).to eq :center }
    end
    
    # accessors
    describe 'accessors' do
      it { expect(subject.page_number_align).to eq :right }
      it { expect(subject.page_number_show).to eq true }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
    
    #=============== SETTERS ==============================
    
    # .align
    describe '.align' do
      before { subject.align(:left) }
      
      it { expect(subject.page_number_align).to eq :left }
    end
    
    # .show
    describe '.show' do
      before { subject.show(true) }
      
      it { expect(subject.page_number_show).to eq true }
    end
    
    
    #=============== VALIDATIONS ==========================
    
    describe '.valid?' do
      describe 'when show is false' do
        before do
          allow(subject).to receive(:page_number_show).and_return(false)
        end
        
        it { expect(subject.valid?).to eq true }
      end
      describe 'when show is true and align is valid' do
        before do
          allow(subject).to receive(:page_number_show).and_return(true)
          allow(subject).to receive(:page_number_align).and_return(:left)
        end
        
        it { expect(subject.valid?).to eq true }
      end
      describe 'when show is true and align is invalid' do
        before do
          allow(subject).to receive(:page_number_show).and_return(true)
          allow(subject).to receive(:page_number_align).and_return(:dummy)
        end
        
        it { expect(subject.valid?).to eq false }
      end
    end
  
  end
  
end
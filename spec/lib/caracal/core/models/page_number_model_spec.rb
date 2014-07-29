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
  
  end
  
end
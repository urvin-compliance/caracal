require 'spec_helper'

describe Caracal::Core::PageNumbers::PageNumbersBlockHandler do
  subject do 
    described_class.new do
      align :right
    end
  end
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # accessors
    describe 'accessors' do
      it { expect(subject.number_align).to eq :right }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
    
    # .align
    describe '.align' do
      before { subject.align(:left) }
      
      it { expect(subject.number_align).to eq :left }
    end
    
    # .to_options
    describe '.to_options' do
      let(:actual)   { subject.to_options }
      let(:expected) { { align: :right } }
      
      it { expect(actual).to eq expected}
    end
  
  end
  
end
require 'spec_helper'

describe Caracal::Core::Models::BaseModel do
  subject { described_class.new }
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
    
    #=============== VALIDATION ===========================
    
    describe '.valid?' do
      it { expect(subject.valid?).to eq true }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Private Methods
  #-------------------------------------------------------------
  
  describe 'private method tests' do
    
    # .option_keys
    describe '.option_keys' do
      let(:actual)   { subject.send(:option_keys).sort }
      let(:expected) { [] }
      
      it { expect(actual).to eq expected }
    end
    
  end
  
end
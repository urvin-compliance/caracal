require 'spec_helper'

describe Caracal::Core::Models::NullModel do
  let(:name) { 'Arial' }
  
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
  
end
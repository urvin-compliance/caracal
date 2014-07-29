require 'spec_helper'

describe Caracal::Core::Models::FontModel do
  let(:name) { 'Arial' }
  
  subject { described_class.new({ name: name }) }
  
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # accessors
    describe 'accessors' do
      it { expect(subject.font_name).to eq 'Arial' }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
    
    #=================== ATTRIBUTES ==========================
    
    # .name
    describe '.name' do
      before do
        subject.name('Helvetica')
      end
      
      it { expect(subject.font_name).to eq 'Helvetica' }
    end
    
    
    #=================== STATE ===============================
    
    # .matches?
    describe '.matches?' do
      describe 'when search term matches' do
        let(:actual) { subject.matches?(name) }
        
        it { expect(actual).to eq true }
      end
      describe 'when search term does not match' do
        let(:actual) { subject.matches?('Dummy') }
        
        it { expect(actual).to eq false }
      end
    end
    
  end
  
end
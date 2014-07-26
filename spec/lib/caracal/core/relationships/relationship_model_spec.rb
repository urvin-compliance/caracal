require 'spec_helper'

describe Caracal::Core::Relationships::RelationshipModel do
  let(:target) { 'footer.xml' }
  let(:type)   { :footer }
  
  subject { described_class.new(target, type) }
  
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # accessors
    describe 'accessors' do
      it { expect(subject.id).to be_a(Integer) }  # number indeterminate due to randomization
      it { expect(subject.type).to eq :footer }
      it { expect(subject.target).to eq 'footer.xml' }
      it { expect(subject.key).to eq 'footer.xml' }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
    
    # .formatted_id
    describe '.formatted_id' do
      before do 
        allow(subject).to receive(:id).and_return(1)
      end 
      
      it { expect(subject.formatted_id).to eq 'rId1' }
    end
    
    # .formatted_type
    describe '.formatted_type' do
      it { expect(subject.formatted_type).to eq 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer' }
    end
    
    # .matches?
    describe '.matches?' do
      describe 'when search term matches key' do
        let(:actual) { subject.matches?('footer.xml') }
        
        it { expect(actual).to eq true }
      end
      describe 'when search term does not match key' do
        let(:actual) { subject.matches?('dummy.xml') }
        
        it { expect(actual).to eq false }
      end
    end
    
    # pending until img command implemented
    pending '#register to be implemented with img command'
    pending '#unregister to be implemented with img command'
  end
  
end
require 'spec_helper'

describe Caracal::Core::Relationships do
  let(:r1) { Caracal::Core::Relationships::RelationshipModel.new('footer.xml', :footer) }
  let(:r2) { Caracal::Core::Relationships::RelationshipModel.new('settings.xml', :setting) }
  
  subject { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    # .relationships
    describe '.relationships' do
      it { expect(subject.relationships).to be_a(Array) }
    end
    
    # .relationship_for_target
    describe '.relationship_for_target' do
      let(:actual)  { subject.relationship_for_target(key) }
      
      before do
        allow(subject).to receive(:relationships).and_return([r1])
      end
      
      describe 'when key is registered' do
        let(:key) { r1.key }
        
        it { expect(actual).to eq r1 }
      end
      describe 'when key is not registered' do
        let(:key) { r2.key }
        
        it { expect(actual).to eq nil }
      end
    end
    
    # .register_relationship
    describe '.register_relationship' do
      let(:default_length) { subject.class.default_relationships.size }
      
      describe 'when not already registered' do
        before do 
          subject.register_relationship(r1.key, r1.type)
        end
        
        it { expect(subject.relationships.size).to eq default_length + 1 }
      end
      describe 'when already registered' do
        before do 
          subject.register_relationship(r1.key, r1.type) 
          subject.register_relationship(r1.key, r1.type)
        end
        
        it { expect(subject.relationships.size).to eq default_length + 1 }
      end
    end
    
    # .unregister_relationship
    describe '.unregister_relationship' do
      let(:default_length) { subject.class.default_relationships.size }
      
      describe 'when registered' do
        before do 
          subject.register_relationship(r1.key, r1.type)
          subject.unregister_relationship(r1.key)
        end
        
        it { expect(subject.relationships.size).to eq default_length }
      end
      describe 'when not registered' do
        before do 
          subject.register_relationship(r1.key, r1.type)
          subject.unregister_relationship(r2.key)
        end
        
        it { expect(subject.relationships.size).to eq default_length }
      end
    end
    
  end
  
end
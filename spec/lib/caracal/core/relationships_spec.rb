require 'spec_helper'

describe Caracal::Core::Relationships do
  let(:r1) { Caracal::Core::Models::RelationshipModel.new({ target: 'footer.xml', type: :footer }) }
  let(:r2) { Caracal::Core::Models::RelationshipModel.new({ target: 'setting.xml', type: :setting }) }
  
  subject  { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Class Methods
  #-------------------------------------------------------------

  describe 'public class tests' do
  
    # .default_relationships
    describe '.default_relationships' do
      let(:expected) { [:font, :footer, :numbering, :setting, :style] }
      let(:actual)   { subject.class.default_relationships.map { |r| r[:type] } }
      
      it { expect(actual).to eq expected }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    #============== GETTERS ========================
    
    # .relationships
    describe '.relationships' do
      it { expect(subject.relationships).to be_a(Array) }
    end
    
    # .find_relationship
    describe '.find_relationship' do
      let(:actual)  { subject.find_relationship(key) }
      
      before do
        allow(subject).to receive(:relationships).and_return([r1])
      end
      
      describe 'when key is registered' do
        let(:key) { r1.relationship_key }
        
        it { expect(actual).to eq r1 }
      end
      describe 'when key is not registered' do
        let(:key) { r2.relationship_key }
        
        it { expect(actual).to eq nil }
      end
    end
    
    
    #============== REGISTRATION ========================
    
    # .register_relationship
    describe '.register_relationship' do
      let(:default_length) { subject.class.default_relationships.size }
      let(:options)        { { target: r1.relationship_target, type: r1.relationship_type } }
      
      describe 'when not already registered' do
        before do 
          subject.register_relationship(options)
        end
        
        it { expect(subject.relationships.size).to eq default_length + 1 }
      end
      describe 'when already registered' do
        before do 
          subject.register_relationship(options) 
          subject.register_relationship(options)
        end
        
        it { expect(subject.relationships.size).to eq default_length + 1 }
      end
    end
    
    # .unregister_relationship
    describe '.unregister_relationship' do
      let(:default_length) { subject.class.default_relationships.size }
      let(:options)        { { target: r1.relationship_target, type: r1.relationship_type } }
      
      describe 'when registered' do
        before do 
          subject.register_relationship(options)
          subject.unregister_relationship(options[:target])
        end
        
        it { expect(subject.relationships.size).to eq default_length }
      end
      describe 'when not registered' do
        before do 
          subject.register_relationship(options)
          subject.unregister_relationship(r2.relationship_key)
        end
        
        it { expect(subject.relationships.size).to eq default_length + 1 }
      end
    end
    
  end
  
end
require 'spec_helper'

describe Caracal::Core::Models::RelationshipModel do
  subject do
    described_class.new do
      id      3
      target  'footer.xml'
      type    :footer
    end
  end
  
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # constants
    describe 'constants' do
      describe 'TYPE_MAP' do
        let(:keys) { described_class::TYPE_MAP.keys }
        
        it { expect(keys.include?(:font)).to be true }
      end
    end
    
    # accessors
    describe 'accessors' do
      it { expect(subject.relationship_id).to eq 3 }
      it { expect(subject.relationship_type).to eq :footer }
      it { expect(subject.relationship_target).to eq 'footer.xml' }
      it { expect(subject.relationship_key).to eq 'footer.xml' }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
    
    #=================== ATTRIBUTES ==========================
    
    # .id
    describe '.id' do
      before { subject.id(3) }
      
      it { expect(subject.relationship_id).to eq 3 }
    end
    
    # .target
    describe '.target' do
      before do
        subject.target('Dummy.XML')
      end
      
      it { expect(subject.relationship_target).to eq 'Dummy.XML' }
      it { expect(subject.relationship_key).to eq 'dummy.xml' }
    end
    
    # .type
    describe '.type' do
      before do
        subject.type('link')
      end
      
      it { expect(subject.relationship_type).to eq :link }
    end
    
    
    #=================== GETTERS =============================
    
    # .formatted_id
    describe '.formatted_id' do
      before do 
        allow(subject).to receive(:relationship_id).and_return(1)
      end 
      
      it { expect(subject.formatted_id).to eq 'rId1' }
    end
    
    # .formatted_target
    describe '.formatted_target' do
      describe 'when image' do
        before do
          allow(subject).to receive(:relationship_id).and_return(2)
          allow(subject).to receive(:relationship_type).and_return(:image)
          allow(subject).to receive(:relationship_target).and_return('https://app.plia.com/images/plia-login.png')
        end
        
        it { expect(subject.formatted_target).to eq 'media/image2.png' }
      end
      describe 'when not image' do
        before do
          allow(subject).to receive(:relationship_type).and_return(:footer)
          allow(subject).to receive(:relationship_target).and_return('footer.xml')
        end
        
        it { expect(subject.formatted_target).to eq 'footer.xml' }
      end
    end
    
    # .formatted_type
    describe '.formatted_type' do
      it { expect(subject.formatted_type).to eq 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer' }
    end
    
    
    #=================== STATE ===============================
    
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
    
    # .target_mode?
    describe '.target_mode?' do
      describe 'when key is link' do
        before do 
          allow(subject).to receive(:relationship_type).and_return(:link)
        end
        
        it { expect(subject.target_mode?).to eq true }
      end
      describe 'when search term does not match key' do
        before do 
          allow(subject).to receive(:relationship_type).and_return(:footer)
        end
        
        it { expect(subject.target_mode?).to eq false }
      end
    end
    
    
    #=============== VALIDATION ===========================
    
    describe '.valid?' do
      describe 'when target and type provided' do
        it { expect(subject.valid?).to eq true }
      end
      [:id, :target, :type].each do |prop|
        describe "when #{ prop } nil" do
          before do
            allow(subject).to receive("relationship_#{ prop }").and_return(nil)
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
      let(:expected) { [:id, :type, :target].sort }
      
      it { expect(actual).to eq expected }
    end
    
  end
  
end
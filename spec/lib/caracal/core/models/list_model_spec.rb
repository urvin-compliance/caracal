require 'spec_helper'

describe Caracal::Core::Models::ListModel do
  subject do 
    described_class.new do
      type    :ordered
      level   1
      li      'Item 1'
    end
  end
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # constants
    describe 'constants' do
      it { expect(described_class::DEFAULT_LIST_TYPE).to eq :unordered }
      it { expect(described_class::DEFAULT_LIST_LEVEL).to eq 0 }
    end
    
    # accessors
    describe 'accessors' do
      it { expect(subject.list_type).to   eq :ordered }
      it { expect(subject.list_level).to  eq 1 }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
  
    #=============== GETTERS ==========================
    
    # .items
    describe '.items' do
      it { expect(subject.items).to be_a(Array) }
    end
    
    # .recursive_items
    describe '.recursive_items' do
      describe 'when no nested lists provided' do
        subject do
          described_class.new type: :ordered, level: 0 do
            li 'Item 1'
            li 'Item 2'
          end
        end
        
        it { expect(subject.recursive_items.size).to eq 2 }
        it { expect(subject.recursive_items[0].list_item_level).to eq 0 }
      end
      describe 'when one nested list provided' do
        subject do
          described_class.new type: :ordered, level: 0 do
            li 'Item 1'
            li 'Item 2' do
              ol do
                li 'SubItem 1'
                li 'SubItem 2'
              end
            end
            li 'Item 3'
          end
        end
        
        it { expect(subject.recursive_items.size).to eq 5 }
        it { expect(subject.recursive_items[0].list_item_level).to eq 0 }
        it { expect(subject.recursive_items[2].list_item_level).to eq 1 }
        it { expect(subject.recursive_items[4].list_item_level).to eq 0 }
      end
      describe 'when more than one nested list provided' do
        subject do
          described_class.new type: :ordered, level: 0 do
            li 'Item 1'
            li 'Item 2' do
              ol do
                li 'SubItem 1' do
                  ul do
                    li 'NestedItem 1'
                  end
                end
                li 'SubItem 2'
              end
            end
            li 'Item 3'
          end
        end
        
        it { expect(subject.recursive_items.size).to eq 6 }
        it { expect(subject.recursive_items[0].list_item_level).to eq 0 }
        it { expect(subject.recursive_items[2].list_item_level).to eq 1 }
        it { expect(subject.recursive_items[3].list_item_level).to eq 2 }
        it { expect(subject.recursive_items[4].list_item_level).to eq 1 }
        it { expect(subject.recursive_items[5].list_item_level).to eq 0 }
      end
    end
    
    
    #=============== SETTERS ==========================
    
    # .type
    describe '.type' do
      before { subject.type(:dummy) }
      
      it { expect(subject.list_type).to eq :dummy }
    end
    
    # .level
    describe '.level' do
      before { subject.level(2) }
      
      it { expect(subject.list_level).to eq 2 }
    end
    
    
    #=============== SUB-METHODS ==========================
    
    # .li
    describe '.li' do
      let!(:length) { subject.items.length }
      
      before { subject.li 'Text' }
      
      it { expect(subject.items.size).to eq length + 1 }
    end
    
    
    #=============== VALIDATION ===========================
    
    describe '.valid?' do
      describe 'when all required attributes provides' do
        it { expect(subject.valid?).to eq true }
      end
      [:type, :level].each do |attr|
        describe "when #{ attr } nil" do
          before do
            allow(subject).to receive("list_#{ attr }").and_return(nil)
          end
        
          it { expect(subject.valid?).to eq false }
        end
      end
      describe 'when items empty' do
        before do
          allow(subject).to receive(:items).and_return([])
        end
      
        it { expect(subject.valid?).to eq false }
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
      let(:expected) { [:type, :level].sort }
      
      it { expect(actual).to eq expected }
    end
    
  end
  
end
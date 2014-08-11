require 'spec_helper'

describe Caracal::Core::Models::ListItemModel do
  subject do 
    described_class.new content: 'Lorem ipsum dolor....' do 
      type        :ordered
      level       2
      style       'Fancy'
      color       '666666'
      size        20
      bold        false
      italic      false
      underline   true
    end
  end
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # accessors
    describe 'accessors' do
      it { expect(subject.respond_to? :nested_list).to eq true }
      it { expect(subject.respond_to? :nested_list=).to eq true }
      it { expect(subject.list_item_type).to eq :ordered }
      it { expect(subject.list_item_level).to eq 2 }
      it { expect(subject.list_item_style).to eq 'Fancy' }
      it { expect(subject.list_item_color).to eq '666666' }
      it { expect(subject.list_item_size).to eq 20 }
      it { expect(subject.list_item_bold).to eq false }
      it { expect(subject.list_item_italic).to eq false }
      it { expect(subject.list_item_underline).to eq true }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
    
    #=============== GETTERS ==========================
    
    # .runs
    describe '.runs' do
      it { expect(subject.runs).to be_a(Array) }
    end
    
    
    #=============== SETTERS ==========================
    
    # booleans
    describe '.bold' do
      before { subject.bold(true) }
      
      it { expect(subject.list_item_bold).to eq true }
    end
    describe '.italic' do
      before { subject.italic(true) }
      
      it { expect(subject.list_item_italic).to eq true }
    end
    describe '.underline' do
      before { subject.underline(true) }
      
      it { expect(subject.list_item_underline).to eq true }
    end
    
    # integers
    describe '.level' do
      before { subject.level(3) }
      
      it { expect(subject.list_item_level).to eq 3 }
    end
    describe '.size' do
      before { subject.size(24) }
      
      it { expect(subject.list_item_size).to eq 24 }
    end
    
    # strings
    describe '.color' do
      before { subject.color('999999') }
      
      it { expect(subject.list_item_color).to eq '999999' }
    end
    describe '.style' do
      before { subject.style('Dummy') }
      
      it { expect(subject.list_item_style).to eq 'Dummy' }
    end
    
    # symbols
    describe '.type' do
      before { subject.type(:ordered) }
      
      it { expect(subject.list_item_type).to eq :ordered }
    end
    
        
    #=============== SUB-METHODS ==========================
    
    # .link
    describe '.link' do
      let!(:length) { subject.runs.length }
      
      before { subject.link 'Text', 'http://www.google.com' }
      
      it { expect(subject.runs.size).to eq length + 1 }
    end
    
    # .text
    describe '.text' do
      let!(:length) { subject.runs.length }
      
      before { subject.text 'Text' }
      
      it { expect(subject.runs.size).to eq length + 1 }
    end
    
    # .ol
    describe '.ol' do
      describe 'when no nested list provided' do
        subject do
          described_class.new type: :ordered, level: 0 do
            text 'Item text.'
          end
        end
      
        it { expect(subject.nested_list).to eq nil }
      end
      describe 'when nested list provided' do
        subject do
          described_class.new type: :ordered, level: 0 do
            text 'Item text.'
            ol do
              li 'Nested item text.'
            end
          end
        end
      
        it { expect(subject.nested_list).to be_a(Caracal::Core::Models::ListModel) }
      end
    end
    
    
    
    #=============== VALIDATION ===========================
    
    describe '.valid?' do
      describe 'when at least one run exists' do
        before do
          allow(subject).to receive(:runs).and_return(['a'])
        end
        
        it { expect(subject.valid?).to eq true }
      end
      describe 'when no runs exist' do
        before do
          allow(subject).to receive(:runs).and_return([])
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
      let(:expected) { [:type, :level, :content, :style, :color, :size, :bold, :italic, :underline].sort }
      
      it { expect(actual).to eq expected }
    end
    
  end
  
end
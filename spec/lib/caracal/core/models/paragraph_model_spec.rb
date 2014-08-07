require 'spec_helper'

describe Caracal::Core::Models::ParagraphModel do
  subject do 
    described_class.new content: 'Lorem ipsum dolor....' do 
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
      it { expect(subject.paragraph_style).to eq 'Fancy' }
      it { expect(subject.paragraph_color).to eq '666666' }
      it { expect(subject.paragraph_size).to eq 20 }
      it { expect(subject.paragraph_bold).to eq false }
      it { expect(subject.paragraph_italic).to eq false }
      it { expect(subject.paragraph_underline).to eq true }
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
    
    # .run_attributes
    describe '.run_attributes' do
      let(:expected) { { color: '666666', size: 20, bold: false, italic: false, underline: true } }
      
      it { expect(subject.run_attributes).to eq expected }
    end
    
    
    #=============== SETTERS ==========================
    
    # booleans
    describe '.bold' do
      before { subject.bold(true) }
      
      it { expect(subject.paragraph_bold).to eq true }
    end
    describe '.italic' do
      before { subject.italic(true) }
      
      it { expect(subject.paragraph_italic).to eq true }
    end
    describe '.underline' do
      before { subject.underline(true) }
      
      it { expect(subject.paragraph_underline).to eq true }
    end
    
    # integers
    describe '.size' do
      before { subject.size(24) }
      
      it { expect(subject.paragraph_size).to eq 24 }
    end
    
    # strings
    describe '.color' do
      before { subject.color('999999') }
      
      it { expect(subject.paragraph_color).to eq '999999' }
    end
    describe '.style' do
      before { subject.style('Dummy') }
      
      it { expect(subject.paragraph_style).to eq 'Dummy' }
    end
    
        
    #=============== SUB-METHODS ==========================
    
    # .link
    describe '.link' do
      let!(:length) { subject.runs.length }
      
      before { subject.link 'Text', 'http://www.plia.com' }
      
      it { expect(subject.runs.size).to eq length + 1 }
    end
    
    # .text
    describe '.text' do
      let!(:length) { subject.runs.length }
      
      before { subject.text 'Text' }
      
      it { expect(subject.runs.size).to eq length + 1 }
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
  
end
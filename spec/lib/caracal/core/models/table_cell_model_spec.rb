require 'spec_helper'

describe Caracal::Core::Models::TableCellModel do
  subject do 
    described_class.new do
      background      'cccccc'
      margins do
        top           101
        bottom        102
        left          103
        right         104
      end
      width           2000
    end
  end
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # constants
    describe 'constants' do
      it { expect(described_class::DEFAULT_CELL_BACKGROUND).to            eq 'ffffff' }
      it { expect(described_class::DEFAULT_CELL_MARGINS).to               be_a(Caracal::Core::Models::MarginModel) }
      it { expect(described_class::DEFAULT_CELL_MARGINS.margin_top).to    eq 0 }
      it { expect(described_class::DEFAULT_CELL_MARGINS.margin_bottom).to eq 0 }
      it { expect(described_class::DEFAULT_CELL_MARGINS.margin_left).to   eq 0 }
      it { expect(described_class::DEFAULT_CELL_MARGINS.margin_right).to  eq 0 }
    end
    
    # accessors
    describe 'accessors' do
      it { expect(subject.cell_background).to     eq 'cccccc' }
      it { expect(subject.cell_margins).to        be_a(Caracal::Core::Models::MarginModel) }
      it { expect(subject.cell_width).to          eq 2000 }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
  
    #=============== DATA ACCESSORS ====================
    
    describe 'data tests' do
      
      # .contents
      describe '.contents' do
        it { expect(subject.contents).to be_a(Array) }
      end
      
    end    
    
    
    #=============== GETTERS ==========================
    
    describe 'getter tests' do
      
      # margin attrs
      describe 'margin attr tests' do
        let(:model) { Caracal::Core::Models::MarginModel.new({ top: 201, bottom: 202, left: 203, right: 204 }) }
        
        before do
          allow(subject).to receive(:cell_margins).and_return(model)
        end
        
        [:top, :bottom, :left, :right].each do |m|
          describe "cell_margin_#{ m }" do
            it { expect(subject.send("cell_margin_#{ m }")).to eq model.send("margin_#{ m }") }
          end
        end
      end
    
    end
    
    
    #=============== SETTERS ==========================
    
    # .background
    describe '.background' do
      before { subject.background('999999') }
      
      it { expect(subject.cell_background).to eq '999999' }
    end
    
    # .width
    describe '.width' do
      before { subject.width(7500) }
      
      it { expect(subject.cell_width).to eq 7500 }
    end
    
    
    #=============== VALIDATION ===========================
    
    describe '.valid?' do
      describe 'when content provided' do
        before { allow(subject).to receive(:contents).and_return(['a']) }
        
        it { expect(subject.valid?).to eq true }
      end
      describe 'when content not provided' do
        before { allow(subject).to receive(:contents).and_return([]) }
        
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
      let(:actual)     { subject.send(:option_keys).sort }
      let(:expected)   { [:background, :width, :margins].sort }
      
      it { expect(actual).to eq expected }
    end
    
  end
  
end
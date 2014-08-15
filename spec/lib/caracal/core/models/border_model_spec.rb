require 'spec_helper'

describe Caracal::Core::Models::BorderModel do
  subject do 
    described_class.new do
      color   '666666'
      size    8
      spacing 2
      line    :double
      type    :horizontal
    end
  end
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # constants
    describe 'constants' do
      it { expect(described_class::DEFAULT_BORDER_COLOR).to   eq 'auto' }
      it { expect(described_class::DEFAULT_BORDER_LINE).to    eq :single }
      it { expect(described_class::DEFAULT_BORDER_SIZE).to    eq 4 }
      it { expect(described_class::DEFAULT_BORDER_SPACING).to eq 1 }
      it { expect(described_class::DEFAULT_BORDER_TYPE).to    eq :top }
    end
    
    # accessors
    describe 'accessors' do
      it { expect(subject.border_color).to   eq '666666' }
      it { expect(subject.border_line).to    eq :double }
      it { expect(subject.border_size).to    eq 8 }
      it { expect(subject.border_spacing).to eq 2 }
      it { expect(subject.border_type).to    eq :horizontal }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
  
    #=============== GETTERS ==========================
    
    # .formatted_type
    describe '.formatted_type' do
      describe 'when horizontal' do
        before do
          allow(subject).to receive(:border_type).and_return(:horizontal)
        end
      
        it { expect(subject.formatted_type).to eq 'insideH'}
      end
      describe 'when vertical' do
        before do
          allow(subject).to receive(:border_type).and_return(:vertical)
        end
      
        it { expect(subject.formatted_type).to eq 'insideV'}
      end
      describe 'when other' do
        before do
          allow(subject).to receive(:border_type).and_return(:top)
        end
      
        it { expect(subject.formatted_type).to eq 'top'}
      end
    end
    
    # .total_size
    describe '.total_size' do
      before do
        allow(subject).to receive(:border_size).and_return(10)
        allow(subject).to receive(:border_spacing).and_return(2)
      end
      
      it { expect(subject.total_size).to eq 14}
    end
    
    
    #=============== SETTERS ==========================
    
    # .color
    describe '.color' do
      before { subject.color('999999') }
      
      it { expect(subject.border_color).to eq '999999' }
    end
    
    # .line
    describe '.line' do
      before { subject.line(:single) }
      
      it { expect(subject.border_line).to eq :single }
    end
    
    # .size
    describe '.size' do
      before { subject.size(24) }
      
      it { expect(subject.border_size).to eq 24 }
    end
    
    # .spacing
    describe '.spacing' do
      before { subject.spacing(8) }
      
      it { expect(subject.border_spacing).to eq 8 }
    end
    
    # .type
    describe '.type' do
      before { subject.type(:bottom) }
      
      it { expect(subject.border_type).to eq :bottom }
    end
    
    
    #=============== VALIDATION ===========================
    
    describe '.valid?' do
      describe 'when all integers gt 0' do
        it { expect(subject.valid?).to eq true }
      end
      [:size, :spacing].each do |d|
        describe "when #{ d } lte 0" do
          before do
            allow(subject).to receive("border_#{ d }").and_return(0)
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
      let(:expected) { [:color, :size, :spacing, :line, :type].sort }
      
      it { expect(actual).to eq expected }
    end
    
  end
  
end
require 'spec_helper'

describe Caracal::Core::Models::MarginModel do
  subject do 
    described_class.new do
      top     1441
      bottom  1442
      left    1443
      right   1444
    end
  end
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # constants
    describe 'constants' do
      it { expect(described_class::DEFAULT_MARGIN_TOP).to eq 1440 }
      it { expect(described_class::DEFAULT_MARGIN_BOTTOM).to eq 1440 }
      it { expect(described_class::DEFAULT_MARGIN_LEFT).to eq 1440 }
      it { expect(described_class::DEFAULT_MARGIN_RIGHT).to eq 1440 }
    end
    
    # accessors
    describe 'accessors' do
      it { expect(subject.margin_top).to     eq 1441 }
      it { expect(subject.margin_bottom).to  eq 1442 }
      it { expect(subject.margin_left).to    eq 1443 }
      it { expect(subject.margin_right).to   eq 1444 }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
  
    #=============== SETTERS ==========================
    
    # .top
    describe '.top' do
      before { subject.top(1000) }
      
      it { expect(subject.margin_top).to eq 1000 }
    end
    
    # .bottom
    describe '.bottom' do
      before { subject.bottom(1000) }
      
      it { expect(subject.margin_bottom).to eq 1000 }
    end
    
    # .left
    describe '.left' do
      before { subject.left(1000) }
      
      it { expect(subject.margin_left).to eq 1000 }
    end
    
    # .right
    describe '.right' do
      before { subject.right(1000) }
      
      it { expect(subject.margin_right).to eq 1000 }
    end
    
    
    #=============== VALIDATION ===========================
    
    describe '.valid?' do
      describe 'when all margins gt 0' do
        it { expect(subject.valid?).to eq true }
      end
      [:top, :bottom, :left, :right].each do |d|
        describe "when #{ d } lte 0" do
          before do
            allow(subject).to receive("margin_#{ d }").and_return(0)
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
      let(:expected) { [:top, :bottom, :left, :right].sort }
      
      it { expect(actual).to eq expected }
    end
    
  end
  
end
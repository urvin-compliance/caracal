require 'spec_helper'

describe Caracal::Core::Models::RuleModel do
  subject do 
    described_class.new do
      color   '666666'
      size    8
      spacing 2
      line    :double
    end
  end
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # constants
    describe 'inheritance' do
      it { expect(subject).to be_a(Caracal::Core::Models::BorderModel) }
    end
    
    # accessors
    describe 'accessors' do
      it { expect(subject.rule_color).to   eq '666666' }
      it { expect(subject.rule_size).to    eq 8 }
      it { expect(subject.rule_spacing).to eq 2 }
      it { expect(subject.rule_line).to    eq :double }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
  
    #=============== SETTERS ==========================
    
    # .color
    describe '.color' do
      before { subject.color('999999') }
      
      it { expect(subject.rule_color).to eq '999999' }
    end
    
    # .line
    describe '.line' do
      before { subject.line(:single) }
      
      it { expect(subject.rule_line).to eq :single }
    end
    
    # .size
    describe '.size' do
      before { subject.size(24) }
      
      it { expect(subject.rule_size).to eq 24 }
    end
    
    # .spacing
    describe '.spacing' do
      before { subject.spacing(8) }
      
      it { expect(subject.rule_spacing).to eq 8 }
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
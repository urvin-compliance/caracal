require 'spec_helper'

describe Caracal::Core::Models::ListStyleModel do
  subject do 
    described_class.new do
      type    :ordered
      level   2
      format  'decimal'
      value   '%3.'
      align   :right
      left    800
      indent  400
      start   2
      restart 2
    end
  end
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # constants
    describe 'constants' do
      it { expect(described_class::DEFAULT_STYLE_ALIGN).to   eq :left  }
      it { expect(described_class::DEFAULT_STYLE_LEFT).to    eq 720    }
      it { expect(described_class::DEFAULT_STYLE_INDENT).to  eq 360    }
      it { expect(described_class::DEFAULT_STYLE_START).to   eq 1      }
      it { expect(described_class::DEFAULT_STYLE_RESTART).to eq 1 }
    end
    
    # accessors
    describe 'accessors' do
      it { expect(subject.style_type).to    eq :ordered   }
      it { expect(subject.style_level).to   eq 2          }
      it { expect(subject.style_format).to  eq 'decimal'  }
      it { expect(subject.style_value).to   eq '%3.'      }
      it { expect(subject.style_align).to   eq :right     }
      it { expect(subject.style_left).to    eq 800        }
      it { expect(subject.style_indent).to  eq 400        }
      it { expect(subject.style_start).to   eq 2          }
      it { expect(subject.style_restart).to eq 2          }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Class Methods
  #-------------------------------------------------------------
  
  describe 'class method tests' do
    subject { described_class }
    
    # .formatted_type
    describe '.formatted_type' do
      it { expect(subject.formatted_type(:ordered)).to eq 1 }
      it { expect(subject.formatted_type(:unordered)).to eq 2 }
    end
    
  end
  
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
    
    #=============== GETTERS ==========================
    
    # .formatted_type
    describe '.formatted_type' do
      describe 'when ordered list' do
        before { allow(subject).to receive(:style_type).and_return(:ordered) }
        
        it { expect(subject.formatted_type).to eq 1 }
      end
      describe 'when unordered list' do
        before { allow(subject).to receive(:style_type).and_return(:unordered) }
        
        it { expect(subject.formatted_type).to eq 2 }
      end
    end
    
    
    #=============== SETTERS ==========================
    
    # booleans
    describe '.restart' do
      before { subject.restart(3) }
      
      it { expect(subject.style_restart).to eq 3 }
    end
    
    # integers
    describe '.level' do
      before { subject.level(2) }
      
      it { expect(subject.style_level).to eq 2 }
    end
    describe '.left' do
      before { subject.left(800) }
      
      it { expect(subject.style_left).to eq 800 }
    end
    describe '.indent' do
      before { subject.indent(400) }
      
      it { expect(subject.style_indent).to eq 400 }
    end
    describe '.start' do
      before { subject.start(2) }
      
      it { expect(subject.style_start).to eq 2 }
    end
    
    # strings
    describe '.format' do
      before { subject.format('decimal') }
      
      it { expect(subject.style_format).to eq 'decimal' }
    end
    describe '.value' do
      before { subject.value('%3.') }
      
      it { expect(subject.style_value).to eq '%3.' }
    end
    
    # symbols
    describe '.type' do
      before { subject.type(:ordered) }
      
      it { expect(subject.style_type).to eq :ordered }
    end
    describe '.align' do
      before { subject.align(:right) }
      
      it { expect(subject.style_align).to eq :right }
    end
    
    
    #=================== STATE ===============================
    
    # .matches?
    describe '.matches?' do
      describe 'when search terms match' do
        let(:actual) { subject.matches?(:ordered, 2) }
        
        it { expect(actual).to eq true }
      end
      describe 'when search term does not match' do
        let(:actual) { subject.matches?(:unordered, 4) }
        
        it { expect(actual).to eq false }
      end
    end
    
    
    #=============== VALIDATION ===========================
    
    describe '.valid?' do
      describe 'when required attributes provided' do
        it { expect(subject.valid?).to eq true }
      end
      [:type, :level, :format, :value].each do |prop|
        describe "when #{ prop } nil" do
          before do
            allow(subject).to receive("style_#{ prop }").and_return(nil)
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
      let(:expected) { [:type, :level, :format, :value, :align, :left, :indent, :start].sort }
      
      it { expect(actual).to eq expected }    
    end
    
  end
  
end
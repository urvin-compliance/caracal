require 'spec_helper'

describe Caracal::Core::Lists do
  subject { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    # .ol
    describe '.ol' do
      let!(:size) { subject.contents.size }
      
      before do 
        subject.ol do
          li 'Item 1'
        end
      end
        
      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::ListModel) }
    end
    
    # .ul
    describe '.ul' do
      let!(:size) { subject.contents.size }
      
      before do 
        subject.ul do
          li 'Item 1'
        end
      end
        
      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::ListModel) }
    end
    
  end
  
end
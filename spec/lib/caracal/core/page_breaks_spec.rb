require 'spec_helper'

describe Caracal::Core::PageBreaks do
  subject { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    # .page
    describe '.page' do
      let!(:size) { subject.contents.size }
      
      before { subject.page }
      
      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::PageBreakModel) }
    end
    
  end
  
end
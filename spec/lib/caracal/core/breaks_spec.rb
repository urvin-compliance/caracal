require 'spec_helper'

describe Caracal::Core::Breaks do
  subject { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    # .br
    describe '.br' do
      let!(:size) { subject.contents.size }
      
      before { subject.br }
      
      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::LineBreakModel) }
    end
    
    # .page
    describe '.page' do
      let!(:size) { subject.contents.size }
      
      before { subject.page }
      
      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::PageBreakModel) }
    end
    
  end
  
end
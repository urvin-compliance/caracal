require 'spec_helper'

describe Caracal::Core::LineBreaks do
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
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::ParagraphModel) }
    end
    
  end
  
end

require 'spec_helper'

describe Caracal::Core::Rules do
  subject { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    # .hr
    describe '.hr' do
      let!(:size) { subject.contents.size }
      
      before { subject.hr }
      
      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::RuleModel) }
    end
    
  end
  
end
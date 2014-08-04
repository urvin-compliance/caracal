require 'spec_helper'

describe Caracal::Core::Models::PageBreakModel do
  let(:name) { 'Arial' }
  
  subject { described_class.new }
  
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------
  
  describe 'configuration tests' do
    
    describe 'inheritance' do
      it { expect(subject).to be_a(Caracal::Core::Models::NullModel) }
    end
    
  end
  
end
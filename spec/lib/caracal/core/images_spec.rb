require 'spec_helper'

describe Caracal::Core::Images do
  subject { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    # .img
    describe '.img' do
      let!(:size) { subject.contents.size }
      
      before { subject.img 'https://app.plia.com/images/plia-login.png', width: 100, height: 120 }
      
      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::ImageModel) }
    end
    
  end
  
end
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
      
      before { subject.img 'https://www.google.com/images/srpr/logo11w.png', width: 538, height: 190 }
      
      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::ImageModel) }
    end
    
  end

end
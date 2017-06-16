require 'spec_helper'

describe Caracal::Core::IFrames do
  subject { Caracal::Document.new }


  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    # .img
    describe '.iframes' do
      let!(:size) { subject.contents.size }

      before do
        path = File.join(Caracal.root, 'spec', 'support', '_fixtures', 'snippet.docx')
        data = File.open(path).read
        subject.iframe data: data
      end

      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::IFrameModel) }
    end

  end

end

require 'spec_helper'

describe Caracal::Core::Bookmarks do
  subject { Caracal::Document.new }


  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    # .bookmark_start
    describe '.bookmark_start' do
      let!(:size) { subject.contents.size }

      before { subject.send('bookmark_start', id: '123', name: 'abc') }

      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::BookmarkModel) }
    end

    # .bookmark_end
    describe '.bookmark_end' do
      let!(:size) { subject.contents.size }

      before { subject.send('bookmark_end', id: '123') }

      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::BookmarkModel) }
    end

  end

end

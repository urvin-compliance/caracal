require 'spec_helper'

describe Caracal::Core::Bookmarks do
  subject { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    # all commands
    [:bookmark_start, :bookmark_end].each do |cmd|
      describe ".#{ cmd }" do
        let!(:size) { subject.contents.size }
      
        before { subject.send(cmd, id: '123', name: 'abc') }
      
        it { expect(subject.contents.size).to eq size + 1 }
        it { expect(subject.contents.last).to be_a(Caracal::Core::Models::BookmarkModel) }
      end
    end
    
  end
  
end

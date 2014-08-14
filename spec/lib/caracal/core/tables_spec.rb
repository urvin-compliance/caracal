require 'spec_helper'

describe Caracal::Core::Tables do
  subject { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    # .table
    describe '.table' do
      let!(:size) { subject.contents.size }
      
      before { subject.table [['Sample Text']] }
      
      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::TableModel) }
    end
    
  end
  
end
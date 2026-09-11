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
      it { expect(subject.contents.last.table_header_rows).to eq(0) }
      
      context 'when .header_rows' do
        before { subject.table [['Sample Text']] do header_rows 1 end }

        it { expect(subject.contents.last.table_header_rows).to eq(1) }
      end
    end
    
  end
  
end

require 'spec_helper'

describe Caracal::Core::Header do
  subject { Caracal::Document.new }

  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do

    # accessors
    describe 'accessors' do
      it { expect(subject.header_content).to be_nil }
    end
  end

  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    describe '.header' do
      describe 'when content provided' do
        before { subject.header { p 'Acme Corp' } }

        it { expect(subject.header_content).to be_a(Caracal::Core::Models::HeaderModel) }
        it { expect(subject.header_content.contents.size).to eq 1 }
      end

      describe 'when content not provided' do
        it { expect { subject.header }.to raise_error(Caracal::Errors::InvalidModelError) }
      end

      describe 'for the first page' do
        before { subject.header(first: true) { p 'Cover' } }

        it { expect(subject.first_header_content.contents.size).to eq 1 }
        it { expect(subject.header_content).to be_nil }
      end

      describe 'for the first page without content' do
        it { expect { subject.header(first: true) }.not_to raise_error }
      end
    end
  end
end

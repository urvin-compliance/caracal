require 'spec_helper'

describe Caracal::Core::Footer do
  subject { Caracal::Document.new }

  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do

    # accessors
    describe 'accessors' do
      it { expect(subject.footer_content).to be_nil }
    end
  end

  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    describe '.footer' do
      describe 'when content provided' do
        before { subject.footer { p 'Acme Corp' } }

        it { expect(subject.footer_content).to be_a(Caracal::Core::Models::FooterModel) }
        it { expect(subject.footer_content.contents.size).to eq 1 }
      end

      describe 'when content not provided' do
        it { expect { subject.footer }.to raise_error(Caracal::Errors::InvalidModelError) }
      end
    end
  end
end

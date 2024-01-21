require 'spec_helper'

describe Caracal::Core::Models::HeaderModel do
  subject do
    described_class.new
  end

  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    #=============== DATA ACCESSORS ====================

    describe 'data tests' do

      # .contents
      describe '.contents' do
        it { expect(subject.contents).to be_a(Array) }
      end
    end

    #=============== VALIDATION ========================

    describe '.valid?' do
      describe 'when content provided' do
        before { allow(subject).to receive(:contents).and_return(['a']) }

        it { expect(subject.valid?).to eq true }
      end

      describe 'when content not provided' do
        before { allow(subject).to receive(:contents).and_return([]) }

        it { expect(subject.valid?).to eq false }
      end
    end
  end
end

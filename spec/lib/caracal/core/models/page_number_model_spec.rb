require 'spec_helper'

describe Caracal::Core::Models::PageNumberModel do
  subject do
    described_class.new do
      show        true
      align       :right
      label       'Page'
      label_size  24
      number_size 20
    end
  end

  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do

    # constants
    describe 'constants' do
      it { expect(described_class::DEFAULT_PAGE_NUMBER_ALIGN).to eq :center }
    end

    # accessors
    describe 'accessors' do
      it { expect(subject.page_number_align).to eq :right }
      it { expect(subject.page_number_label).to eq 'Page' }
      it { expect(subject.page_number_label_size).to eq 24 }
      it { expect(subject.page_number_number_size).to eq 20 }
      it { expect(subject.page_number_show).to eq true }
    end

  end


  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    #=============== SETTERS ==============================

    # .align
    describe '.align' do
      before { subject.align(:left) }

      it { expect(subject.page_number_align).to eq :left }
    end

    # .label
    describe '.label' do
      before { subject.label('Page') }

      it { expect(subject.page_number_label).to eq 'Page' }
    end

    # .label_size
    describe '.label_size' do
      before { subject.label_size(28) }

      it { expect(subject.page_number_label_size).to eq 28 }
    end

    # .number_size
    describe '.number_size' do
      before { subject.number_size(28) }

      it { expect(subject.page_number_number_size).to eq 28 }
    end

    # .show
    describe '.show' do
      before { subject.show(true) }

      it { expect(subject.page_number_show).to eq true }
    end

    # .size
    describe '.size' do
      before { subject.size(32) }

      it { expect(subject.page_number_label_size).to eq 32 }
      it { expect(subject.page_number_number_size).to eq 32 }
    end


    #=============== VALIDATIONS ==========================

    describe '.valid?' do
      describe 'when show is false' do
        before do
          allow(subject).to receive(:page_number_show).and_return(false)
        end

        it { expect(subject.valid?).to eq true }
      end
      describe 'when show is true and align is valid' do
        before do
          allow(subject).to receive(:page_number_show).and_return(true)
          allow(subject).to receive(:page_number_align).and_return(:left)
        end

        it { expect(subject.valid?).to eq true }
      end
      describe 'when show is true and align is invalid' do
        before do
          allow(subject).to receive(:page_number_show).and_return(true)
          allow(subject).to receive(:page_number_align).and_return(:dummy)
        end

        it { expect(subject.valid?).to eq false }
      end
    end

  end


  #-------------------------------------------------------------
  # Private Methods
  #-------------------------------------------------------------

  describe 'private method tests' do

    # .option_keys
    describe '.option_keys' do
      let(:actual)   { subject.send(:option_keys).sort }
      let(:expected) { [:align, :label, :label_size, :number_size, :show].sort }

      it { expect(actual).to eq expected }
    end

  end

end

require 'spec_helper'

describe Caracal::Core::PageSettings do
  subject { Caracal::Document.new }
  
    
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # constants
    describe 'page number constants' do
      it { expect(subject.class::DEFAULT_PAGE_NUMBER_ALIGN).to  eq :center }
    end
      
    # readers
    describe 'page number readers' do
      it { expect(subject.page_number_label).to eq nil }
      it { expect(subject.page_number_show).to eq false }
      it { expect(subject.page_number_align).to eq :center }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public methods tests' do
    
    # .page_numbers
    describe '.page_numbers' do
      describe 'when nothing given' do
        before { subject.page_numbers }

        it { expect(subject.page_number_label).to eq nil }
        it { expect(subject.page_number_show).to eq false }
        it { expect(subject.page_number_align).to eq :center }
      end
      describe 'when explicitly turned off' do
        before { subject.page_numbers false }

        it { expect(subject.page_number_label).to eq nil }
        it { expect(subject.page_number_show).to eq false }
        it { expect(subject.page_number_align).to eq :center }
      end
      describe 'when options given' do
        before { subject.page_numbers true, label: 'Custom Text', align: :left }

        it { expect(subject.page_number_label).to eq 'Custom Text' }
        it { expect(subject.page_number_show).to eq true }
        it { expect(subject.page_number_align).to eq :left }
      end
      describe 'when block given' do
        before do
          subject.page_numbers true do
            label 'More Text'
            align :left
          end
        end

        it { expect(subject.page_number_label).to eq 'More Text' }
        it { expect(subject.page_number_show).to eq true }
        it { expect(subject.page_number_align).to eq :left }
      end
      describe 'when fancy block given' do
        subject do
          Caracal::Document.new do |docx|
            t = 'This is text'
            a = :left
            docx.page_numbers true do
              label t
              align a
            end
          end
        end

        it { expect(subject.page_number_label).to eq 'This is text' }
        it { expect(subject.page_number_show).to eq true }
        it { expect(subject.page_number_align).to eq :left }
      end
    end
    
  end
  
end
require 'spec_helper'

describe Caracal::Core::PageSettings do
  subject { Caracal::Document.new }


  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do

    # readers
    describe 'page size readers' do
      it { expect(subject.page_width).to eq 12240 }
      it { expect(subject.page_height).to eq 15840 }
      it { expect(subject.page_orientation).to eq 'portrait' }
    end
    describe 'page margin readers' do
      it { expect(subject.page_margin_top).to    eq 1440 }
      it { expect(subject.page_margin_bottom).to eq 1440 }
      it { expect(subject.page_margin_left).to   eq 1440 }
      it { expect(subject.page_margin_right).to  eq 1440 }
    end

  end


  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public methods tests' do

    # .page_size
    describe '.page_size' do
      describe 'when options given' do
        before { subject.page_size width: 10000, height: 12000, orientation: :landscape }

        it { expect(subject.page_width).to eq 10000 }
        it { expect(subject.page_height).to eq 12000 }
        it { expect(subject.page_orientation).to eq 'landscape' }
      end
      describe 'when block given' do
        before do
          subject.page_size do
            width       10000
            height      12000
            orientation :landscape
          end
        end

        it { expect(subject.page_width).to eq 10000 }
        it { expect(subject.page_height).to eq 12000 }
        it { expect(subject.page_orientation).to eq 'landscape' }
      end
      describe 'when fancy block given' do
        subject do
          Caracal::Document.new do |docx|
            w = 10000
            h = 12000
            o = :landscape
            docx.page_size do
              width       w
              height      h
              orientation o
            end
          end
        end

        it { expect(subject.page_width).to eq 10000 }
        it { expect(subject.page_height).to eq 12000 }
        it { expect(subject.page_orientation).to eq 'landscape' }
      end
      describe 'when both given' do
        before do
          subject.page_size width: 10000, orientation: :landscape do
            height 12000
          end
        end

        it { expect(subject.page_width).to eq 10000 }
        it { expect(subject.page_height).to eq 12000 }
        it { expect(subject.page_orientation).to eq 'landscape' }
      end
    end

    # .page_margins
    describe '.page_margins' do
      describe 'when options given' do
        before { subject.page_margins top: 1441, bottom: 1442, left: 1443, right: 1444 }

        it { expect(subject.page_margin_top).to    eq 1441 }
        it { expect(subject.page_margin_bottom).to eq 1442 }
        it { expect(subject.page_margin_left).to   eq 1443 }
        it { expect(subject.page_margin_right).to  eq 1444 }
      end
      describe 'when block given' do
        before do
          subject.page_margins do
            top    1441
            bottom 1442
            left   1443
            right  1444
          end
        end

        it { expect(subject.page_margin_top).to    eq 1441 }
        it { expect(subject.page_margin_bottom).to eq 1442 }
        it { expect(subject.page_margin_left).to   eq 1443 }
        it { expect(subject.page_margin_right).to  eq 1444 }
      end
      describe 'when fancy block given' do
        subject do
          Caracal::Document.new do |docx|
            t = 1441
            b = 1442
            l = 1443
            r = 1444
            docx.page_margins do
              top    t
              bottom b
              left   l
              right  r
            end
          end
        end

        it { expect(subject.page_margin_top).to    eq 1441 }
        it { expect(subject.page_margin_bottom).to eq 1442 }
        it { expect(subject.page_margin_left).to   eq 1443 }
        it { expect(subject.page_margin_right).to  eq 1444 }
      end
      describe 'when both given' do
        before do
          subject.page_margins top: 1441, left: 1443 do
            bottom 1442
            right  1444
          end
        end

        it { expect(subject.page_margin_top).to    eq 1441 }
        it { expect(subject.page_margin_bottom).to eq 1442 }
        it { expect(subject.page_margin_left).to   eq 1443 }
        it { expect(subject.page_margin_right).to  eq 1444 }
      end
    end

  end

end

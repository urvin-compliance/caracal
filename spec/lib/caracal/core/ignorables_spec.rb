require 'spec_helper'

describe Caracal::Core::Ignorables do
  subject  { Caracal::Document.new }


  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    #============== ATTRIBUTES =====================

    # .ignorable
    describe '.ignorable' do
      it 'delegates to registration method' do
        expect(subject).to receive(:register_ignorable)
        subject.ignorable('dummy')
      end
    end


    #============== GETTERS ========================

    # .ignorables
    describe '.ignorables' do
      it { expect(subject.ignorables).to be_a(Array) }
    end


    #============== REGISTRATION ========================

    # .register_ignorable
    describe '.register_ignorable' do
      let(:default_length) { 0 }

      describe 'when not already registered' do
        before do
          subject.register_ignorable('dummy')
        end

        it { expect(subject.ignorables.size).to eq default_length + 1 }
      end
      describe 'when already registered' do
        before do
          subject.register_ignorable('dummy')
          subject.register_ignorable('dummy')
        end

        it { expect(subject.ignorables.size).to eq default_length + 1 }
      end
    end

    # .unregister_ignorable
    describe '.unregister_ignorable' do
      let(:default_length) { 0 }

      describe 'when registered' do
        before do
          subject.register_ignorable('dummy')
          subject.unregister_ignorable('dummy')
        end

        it { expect(subject.ignorables.size).to eq default_length }
      end
      describe 'when not registered' do
        before do
          subject.register_ignorable('dummy')
          subject.unregister_ignorable('bogus')
        end

        it { expect(subject.ignorables.size).to eq default_length + 1 }
      end
    end

  end

end

require 'spec_helper'

describe Caracal::Core::Models::NamespaceModel do
  subject do
    described_class.new do
      prefix  'com'
      href    'http://www.example.com'
    end
  end


  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do

    # accessors
    describe 'accessors' do
      it { expect(subject.namespace_prefix).to eq 'com' }
      it { expect(subject.namespace_href).to   eq 'http://www.example.com' }
    end

  end


  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    #=================== ATTRIBUTES ==========================

    # .prefix
    describe '.prefix' do
      before do
        subject.prefix('org')
      end

      it { expect(subject.namespace_prefix).to eq 'org' }
    end

    # .href
    describe '.href' do
      before do
        subject.href('http://www.example.org')
      end

      it { expect(subject.namespace_href).to eq 'http://www.example.org' }
    end


    #=================== STATE ===============================

    # .matches?
    describe '.matches?' do
      describe 'when search term matches key' do
        let(:actual) { subject.matches?('com') }

        it { expect(actual).to eq true }
      end
      describe 'when search term does not match key' do
        let(:actual) { subject.matches?('org') }

        it { expect(actual).to eq false }
      end
    end


    #=============== VALIDATION ===========================

    describe '.valid?' do
      describe 'when prefix and href provided' do
        it { expect(subject.valid?).to eq true }
      end
      [:prefix, :href].each do |prop|
        describe "when #{ prop } nil" do
          before do
            allow(subject).to receive("namespace_#{ prop }").and_return(nil)
          end

          it { expect(subject.valid?).to eq false }
        end
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
      let(:expected) { [:prefix, :href].sort }

      it { expect(actual).to eq expected }
    end

  end

end

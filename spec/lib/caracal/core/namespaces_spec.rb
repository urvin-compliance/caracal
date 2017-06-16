require 'spec_helper'

describe Caracal::Core::Namespaces do
  let(:m1) { Caracal::Core::Models::NamespaceModel.new({ prefix: 'com', href: 'http://www.example.com' }) }
  let(:m2) { Caracal::Core::Models::NamespaceModel.new({ prefix: 'org', href: 'http://www.example.org' }) }

  subject  { Caracal::Document.new }


  #-------------------------------------------------------------
  # Class Methods
  #-------------------------------------------------------------

  describe 'public class tests' do

    # .default_namespaces
    describe '.default_namespaces' do
      it { expect(subject.class.default_namespaces).to be_a(Array) }
    end

  end


  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    #============== ATTRIBUTES =====================

    # .namespace
    describe '.namespace' do
      it 'delegates to registration method' do
        expect(subject).to receive(:register_namespace)
        subject.namespace({ prefix: 'dummy', href: 'http://www.dummy.com' })
      end
    end


    #============== GETTERS ========================

    # .namespaces
    describe '.namespaces' do
      it { expect(subject.namespaces).to be_a(Array) }
    end

    # .find_namespace
    describe '.find_namespace' do
      let(:actual)  { subject.find_namespace(key) }

      before do
        allow(subject).to receive(:namespaces).and_return([m1])
      end

      describe 'when key is registered' do
        let(:key) { m1.namespace_prefix }

        it { expect(actual).to eq m1 }
      end
      describe 'when key is not registered' do
        let(:key) { m2.namespace_prefix }

        it { expect(actual).to eq nil }
      end
    end


    #============== REGISTRATION ========================

    # .register_namespace
    describe '.register_namespace' do
      let(:default_length) { subject.class.default_namespaces.size }

      describe 'when not already registered' do
        before do
          subject.register_namespace(m1)
        end

        it { expect(subject.namespaces.size).to eq default_length + 1 }
      end
      describe 'when already registered' do
        before do
          subject.register_namespace(m1)
          subject.register_namespace(m1)
        end

        it { expect(subject.namespaces.size).to eq default_length + 1 }
      end
    end

    # .unregister_namespace
    describe '.unregister_namespace' do
      let(:default_length) { subject.class.default_namespaces.size }

      describe 'when registered' do
        before do
          subject.register_namespace(m1)
          subject.unregister_namespace(m1.namespace_prefix)
        end

        it { expect(subject.namespaces.size).to eq default_length }
      end
      describe 'when not registered' do
        before do
          subject.register_namespace(m1)
          subject.unregister_namespace(m2.namespace_prefix)
        end

        it { expect(subject.namespaces.size).to eq default_length + 1 }
      end
    end

  end

end

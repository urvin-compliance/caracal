require 'spec_helper'

describe Caracal::Core::Styles do
  let(:s1) { Caracal::Core::Models::StyleModel.new({ id: 'Dummy', name: 'dummy' }) }
  let(:s2) { Caracal::Core::Models::StyleModel.new({ id: 'Fake',  name: 'fake' }) }
  
  subject  { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Class Methods
  #-------------------------------------------------------------

  describe 'public class tests' do
  
    # .default_styles
    describe '.default_styles' do
      let(:expected) { ['Normal', 'Heading1', 'Heading2', 'Heading3', 'Heading4', 'Heading5', 'Heading6', 'Title', 'Subtitle'].sort }
      let(:actual)   { subject.class.default_styles.map { |s| s[:id] }.sort }

      it {expect(actual).to eq expected }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    #============== ATTRIBUTES =====================
    
    # .style
    describe '.style' do
      it 'delegates to registration method' do
        expect(subject).to receive(:register_style)
        subject.style({ id: 'heading2', name: 'Heading 2' })
      end
    end
    
    
    #============== GETTERS ========================
    
    # .styles
    describe '.styles' do
      it { expect(subject.styles).to be_a(Array) }
    end
    
    # .default_style
    describe '.default_style' do
      before do
        allow(s1).to receive(:style_default).and_return(true)
        allow(subject).to receive(:styles).and_return([s1,s2])
      end
      
      it { expect(subject.default_style).to eq s1 }
    end
    
    # .find_style
    describe '.find_style' do
      let(:actual)  { subject.find_style(key) }
      
      before do
        allow(subject).to receive(:styles).and_return([s1])
      end
      
      describe 'when key is registered' do
        let(:key) { s1.style_id }
        
        it { expect(actual).to eq s1 }
      end
      describe 'when key is not registered' do
        let(:key) { s2.style_id }
        
        it { expect(actual).to eq nil }
      end
    end
    
    
    #============== REGISTRATION ========================
    
    # .register_style
    describe '.register_style' do
      let(:default_length) { subject.class.default_styles.size }
      
      describe 'when not already registered' do
        before do 
          subject.register_style(s1)
        end
        
        it { expect(subject.styles.size).to eq default_length + 1 }
      end
      describe 'when already registered' do
        before do 
          subject.register_style(s1) 
          subject.register_style(s1)
        end
        
        it { expect(subject.styles.size).to eq default_length + 1 }
      end
    end
    
    # .unregister_style
    describe '.unregister_style' do
      let(:default_length) { subject.class.default_styles.size }
      
      describe 'when registered' do
        before do 
          subject.register_style(s1)
          subject.unregister_style(s1.style_id)
        end
        
        it { expect(subject.styles.size).to eq default_length }
      end
      describe 'when not registered' do
        before do 
          subject.register_style(s1)
          subject.unregister_style(s2.style_id)
        end
        
        it { expect(subject.styles.size).to eq default_length + 1 }
      end
    end
    
  end
  
end
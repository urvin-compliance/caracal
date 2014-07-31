require 'spec_helper'

describe Caracal::Core::ListStyles do
  let(:s1) { Caracal::Core::Models::ListStyleModel.new({ type: :ordered, level: 10, format: 'decimal',     value: '%1.' }) }
  let(:s2) { Caracal::Core::Models::ListStyleModel.new({ type: :ordered, level: 11, format: 'lowerLetter', value: '%2.' }) }
  
  subject  { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Class Methods
  #-------------------------------------------------------------

  describe 'public class tests' do
  
    # .default_list_styles
    describe '.default_list_styles' do
      let(:expected) { 18 }
      let(:actual)   { subject.class.default_list_styles.size }

      it {expect(actual).to eq expected }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    #============== ATTRIBUTES =====================
    
    # .list_style
    describe '.list_style' do
      it 'delegates to registration method' do
        expect(subject).to receive(:register_list_style)
        subject.list_style({ type: :ordered, level: 2, format: 'decimal', value: '2f.' })
      end
    end
    
    
    #============== GETTERS ========================
    
    # .list_styles
    describe '.list_styles' do
      it { expect(subject.list_styles).to be_a(Array) }
    end
    
    # .find_list_style
    describe '.find_list_style' do
      let(:actual)  { subject.find_list_style(type, level) }
      
      before do
        allow(subject).to receive(:list_styles).and_return([s1])
      end
      
      describe 'when key is registered' do
        let(:type)  { s1.style_type  }
        let(:level) { s1.style_level }
        
        it { expect(actual).to eq s1 }
      end
      describe 'when key is not registered' do
        let(:type)  { s2.style_type  }
        let(:level) { s2.style_level }
        
        it { expect(actual).to eq nil }
      end
    end
    
    
    #============== REGISTRATION ========================
    
    # .register_list_style
    describe '.register_list_style' do
      let(:default_length) { subject.class.default_list_styles.size }
      
      describe 'when not already registered' do
        before do 
          subject.register_list_style(s1)
        end
        
        it { expect(subject.list_styles.size).to eq default_length + 1 }
      end
      describe 'when already registered' do
        before do 
          subject.register_list_style(s1) 
          subject.register_list_style(s1)
        end
        
        it { expect(subject.list_styles.size).to eq default_length + 1 }
      end
    end
    
    # .unregister_list_style
    describe '.unregister_list_style' do
      let(:default_length) { subject.class.default_list_styles.size }
      
      describe 'when registered' do
        before do 
          subject.register_list_style(s1)
          subject.unregister_list_style(s1.style_type, s1.style_level)
        end
        
        it { expect(subject.list_styles.size).to eq default_length }
      end
      describe 'when not registered' do
        before do 
          subject.register_list_style(s1)
          subject.unregister_list_style(s2.style_type, s2.style_level)
        end
        
        it { expect(subject.list_styles.size).to eq default_length + 1 }
      end
    end
    
  end
  
end
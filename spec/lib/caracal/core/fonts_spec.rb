require 'spec_helper'

describe Caracal::Core::Fonts do
  let(:f1) { Caracal::Core::Models::FontModel.new({ name: 'Helvetica' }) }
  let(:f2) { Caracal::Core::Models::FontModel.new({ name: 'Garamond' }) }
  
  subject { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Class Methods
  #-------------------------------------------------------------

  describe 'public class tests' do
  
    # .default_fonts
    describe '.default_fonts' do
      let(:expected) { ['Arial', 'Trebuchet MS'] }
      let(:actual)   { subject.class.default_fonts.map { |r| r[:name] } }
      
      it { expect(actual).to eq expected }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    #============== ATTRIBUTES =====================
    
    # .font
    describe '.font' do
      it 'delegates font to registration method' do
        expect(subject).to receive(:register_font)
        subject.font({ name: 'Helvetica' })
      end
    end
    
    
    #============== GETTERS ========================
    
    # .fonts
    describe '.fonts' do
      it { expect(subject.fonts).to be_a(Array) }
    end
    
    # .find_font
    describe '.find_font' do
      let(:actual)  { subject.find_font(key) }
      
      before do
        allow(subject).to receive(:fonts).and_return([f1])
      end
      
      describe 'when key is registered' do
        let(:key) { f1.font_name }
        
        it { expect(actual).to eq f1 }
      end
      describe 'when key is not registered' do
        let(:key) { f2.font_name }
        
        it { expect(actual).to eq nil }
      end
    end
    
    
    #============== REGISTRATION ========================
    
    # .register_font
    describe '.register_font' do
      let(:default_length) { subject.class.default_fonts.size }
      
      describe 'when not already registered' do
        before do 
          subject.register_font(f1)
        end
        
        it { expect(subject.fonts.size).to eq default_length + 1 }
      end
      describe 'when already registered' do
        before do 
          subject.register_font(f1) 
          subject.register_font(f1)
        end
        
        it { expect(subject.fonts.size).to eq default_length + 1 }
      end
    end
    
    # .unregister_font
    describe '.unregister_font' do
      let(:default_length) { subject.class.default_fonts.size }
      
      describe 'when registered' do
        before do 
          subject.register_font(f1)
          subject.unregister_font(f1.font_name)
        end
        
        it { expect(subject.fonts.size).to eq default_length }
      end
      describe 'when not registered' do
        before do 
          subject.register_font(f1)
          subject.unregister_font(f2.font_name)
        end
        
        it { expect(subject.fonts.size).to eq default_length + 1 }
      end
    end
    
  end
  
end
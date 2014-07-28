require 'spec_helper'

describe Caracal::Core::Fonts do
  subject { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Class Methods
  #-------------------------------------------------------------

  describe 'public class tests' do
  
    # .default_fonts
    describe '.default_fonts' do
      let(:expected) { ['Arial', 'Droid Serif'] }
      let(:actual)   { subject.class.default_fonts.map { |r| r[:name] } }
      
      it { expect(actual).to eq expected }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    # .font
    describe '.font' do
      let!(:previous_size)  { subject.fonts.size }
      
      describe 'when new argument provided' do
        before { subject.font('Dummy') }
        
        it { expect(subject.fonts.size).to eq (previous_size + 1) }
      end
      describe 'when argument provided again' do
        before do
          subject.font('Dummy')
          subject.font('dummy')
        end
        
        it { expect(subject.fonts.size).to eq (previous_size + 1) }
      end
    end
    
  end
  
end
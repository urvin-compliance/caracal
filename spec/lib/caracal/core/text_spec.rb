require 'spec_helper'

describe Caracal::Core::Text do
  subject { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    # all commands
    [:p, :h1, :h2, :h3, :h4, :h5, :h6].each do |cmd|
      describe ".#{ cmd }" do
        let!(:size) { subject.contents.size }
      
        before { subject.send(cmd, 'Smaple text.') }
      
        it { expect(subject.contents.size).to eq size + 1 }
        it { expect(subject.contents.last).to be_a(Caracal::Core::Models::ParagraphModel) }
      end
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Private Methods
  #-------------------------------------------------------------

  describe 'private method tests' do
    
    # .style_id_for_header
    describe '.style_id_for_header' do
      (1..6).each do |i|
        describe "when h#{ i }" do
          let(:actual) { subject.send(:style_id_for_header, "h#{ i }") }
          
          it { expect(actual).to eq "Heading#{ i }" }
        end
      end
      describe 'when unknown return normal' do
        let(:actual) { subject.send(:style_id_for_header, 'Dummy') }
        
        it { expect(actual).to eq 'Normal' }
      end
    end
    
  end
  
end
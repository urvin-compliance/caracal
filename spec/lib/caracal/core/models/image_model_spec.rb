require 'spec_helper'

describe Caracal::Core::Models::ImageModel do
  subject do 
    described_class.new do
      url    'https://app.plia.com/images/plia-login.png'
      width   250
      height  200
      align   :right
      top     12
      bottom  13
      left    14
      right   15
    end
  end
  
  
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # constants
    describe 'constants' do
      it { expect(described_class::DEFAULT_IMAGE_WIDTH).to eq 0 }
      it { expect(described_class::DEFAULT_IMAGE_HEIGHT).to eq 0 }
      it { expect(described_class::DEFAULT_IMAGE_ALIGN).to eq :left }
      it { expect(described_class::DEFAULT_IMAGE_TOP).to eq 8 }
      it { expect(described_class::DEFAULT_IMAGE_BOTTOM).to eq 8 }
      it { expect(described_class::DEFAULT_IMAGE_LEFT).to eq 8 }
      it { expect(described_class::DEFAULT_IMAGE_RIGHT).to eq 8 }
    end
    
    # accessors
    describe 'accessors' do
      it { expect(subject.image_url).to    eq 'https://app.plia.com/images/plia-login.png' }
      it { expect(subject.image_width).to  eq 250 }
      it { expect(subject.image_height).to eq 200 }
      it { expect(subject.image_align).to  eq :right }
      it { expect(subject.image_top).to    eq 12 }
      it { expect(subject.image_bottom).to eq 13 }
      it { expect(subject.image_left).to   eq 14 }
      it { expect(subject.image_right).to  eq 15 }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
  
    #=============== GETTERS ==========================
    
    # emu conversions
    [:width, :height, :top, :bottom, :left, :right].each do |m|
      describe ".formatted_#{ m }" do
        let(:actual) { subject.send("formatted_#{ m }") }
        
        before { allow(subject).to receive("image_#{ m }").and_return(9) }
        
        it { expect(actual).to eq 114300 }
      end
    end
    
    
    #=============== SETTERS ==========================
    
    # .url
    describe '.color' do
      before { subject.url('https://app.plia.com/images/dummy.png') }
      
      it { expect(subject.image_url).to eq 'https://app.plia.com/images/dummy.png' }
    end
    
    # .width
    describe '.width' do
      before { subject.width(300) }
      
      it { expect(subject.image_width).to eq 300 }
    end
    
    # .height
    describe '.height' do
      before { subject.height(400) }
      
      it { expect(subject.image_height).to eq 400 }
    end
    
    # .align
    describe '.align' do
      before { subject.align(:center) }
      
      it { expect(subject.image_align).to eq :center }
    end
    
    # .top
    describe '.top' do
      before { subject.top(12) }
      
      it { expect(subject.image_top).to eq 12 }
    end
    
    # .bottom
    describe '.bottom' do
      before { subject.bottom(12) }
      
      it { expect(subject.image_bottom).to eq 12 }
    end
    
    # .left
    describe '.left' do
      before { subject.left(12) }
      
      it { expect(subject.image_left).to eq 12 }
    end
    
    # .right
    describe '.right' do
      before { subject.right(12) }
      
      it { expect(subject.image_right).to eq 12 }
    end
    
    
    #=============== VALIDATION ===========================
    
    describe '.valid?' do
      describe 'when all values okay' do
        it { expect(subject.valid?).to eq true }
      end
      [:width, :height, :top, :bottom, :left, :right].each do |d|
        describe "when #{ d } lte 0" do
          before do
            allow(subject).to receive("image_#{ d }").and_return(0)
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
  
    # .pixels_to_emus
    describe '.pixels_to_emus' do
      let(:actual) { subject.send(:pixels_to_emus, value) }
      
      describe 'when argument is nil' do
        let(:value) { nil }
        
        it { expect(actual).to eq 0 }
      end
      describe 'when argument is NaN' do
        let(:value) { 'a' }
        
        it { expect(actual).to eq 0 }
      end
      describe 'when argument is rational' do
        let(:value) { 396.1 }
        
        it { expect(actual).to eq 5029200 }
      end
      describe 'when argument is integer' do
        let(:value) { 396 }
        
        it { expect(actual).to eq 5029200 }
      end
    end
    
  end
  
end
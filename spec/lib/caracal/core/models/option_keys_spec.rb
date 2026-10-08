require 'spec_helper'

# BaseModel#initialize silently drops any option that isn't in the model's
# option_keys, so a setter missing from that list only works in the block
# form: `img url, data: bytes` ignored `data` until #172. This checks every
# model's public one-argument setters against its option_keys.
describe 'model option keys' do
  # methods that take one argument but are not user settings
  INTERNAL = {
    'Caracal::Core::Models::TableModel'     => [:calculate_width],
    'Caracal::Core::Models::TableCellModel' => [:calculate_width]
  }

  models = ObjectSpace.each_object(Class).select { |c| c < Caracal::Core::Models::BaseModel }

  models.sort_by(&:name).each do |klass|
    it "#{ klass.name.split('::').last } accepts every setter as an option" do
      keys    = klass.allocate.send(:option_keys)
      setters = klass.public_instance_methods.select do |m|
        owner = klass.instance_method(m).owner
        owner <= klass && owner != Caracal::Core::Models::BaseModel &&
          klass.instance_method(m).arity == 1 && !m.to_s.end_with?('?', '=')
      end

      expect(setters - keys - INTERNAL.fetch(klass.name, [])).to be_empty
    end
  end

  describe 'settings that used to be block-only' do
    it { expect(Caracal::Core::Models::ParagraphModel.new(keep_next: true).paragraph_keep_next).to eq true }
    it { expect(Caracal::Core::Models::TableModel.new(data: [['a'], ['b']], header_rows: 1).table_header_rows).to eq 1 }
    it { expect(Caracal::Core::Models::ListStyleModel.new(restart: 0).style_restart).to eq 0 }

    it 'sizes the page number label and number with size' do
      model = Caracal::Core::Models::PageNumberModel.new(size: 24)

      expect([model.page_number_label_size, model.page_number_number_size]).to eq [24, 24]
    end

    it 'passes keep_next through the document API' do
      docx = Caracal::Document.new
      docx.p 'heading', keep_next: true

      expect(docx.contents.last.paragraph_keep_next).to eq true
    end
  end
end

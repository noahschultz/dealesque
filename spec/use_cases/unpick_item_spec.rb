require 'spec_helper_without_rails'

describe UnpickItem do
  context "when unpicking" do
    let(:item) { Item.new }
    let(:picked_items_container) { PickedItems.new }
    let(:subject) { UnpickItem.new(picked_items_container) }

    before(:each) do
      picked_items_container.add(item)
    end

    it "removes item from picked item container" do
      subject.unpick(item)
      expect(picked_items_container.include?(item)).to eq(false)
    end
  end

  context "when initializing" do
    it "requires picked items container" do
      expect { UnpickItem.new(nil) }.to raise_error(ArgumentError)
    end
  end
end
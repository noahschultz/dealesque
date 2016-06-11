require 'spec_helper_without_rails'

describe PickedItemsRepresenter do
  context "when representing" do
    let(:picked_items) do
      PickedItems.new.tap do |p|
        p.add Item.new(id: "A1")
        p.add Item.new(id: "A2")
      end
    end

    context "to JSON" do
      it "represents items" do
        json_representation = PickedItemsRepresenter.new(picked_items).to_json
        expect(json_representation).to have_json_path("items")
        expect(json_representation).to have_json_size(2).at_path("items")
      end
    end
  end

  context "when consuming" do
    context "from JSON" do
      let(:json) { %({"items":[{},{}]}) }

      it "consumes items" do
        picked_items = PickedItems.new
        PickedItemsRepresenter.new(picked_items).from_json(json)
        expect(picked_items.size).to eq(2)
        picked_items.items.each do |item|
          expect(item).to be_a_kind_of(Item)
        end
      end
    end
  end
end
require 'spec_helper_without_rails'

describe ItemImageRepresenter do
  context "when representing" do
    let(:item_image) { ItemImage.new(url: "http://amazon", height: 100, width: 50, type: :small) }

    context "to JSON" do
      it "represents properties" do
        names = %({"url":"http://amazon","height":100,"width":50,"type":"small"})
        expect(ItemImageRepresenter.new(item_image).to_json).to be_json_eql(names)
      end
    end
  end

  context "when consuming" do
    context "from JSON" do
      let(:json) { %({"url":"http://amazon","height":100,"width":50,"type":"small"}) }

      it "consumes properties" do
        item_image = ItemImage.new
        ItemImageRepresenter.new(item_image).from_json(json)
        expect(item_image.url).to eq("http://amazon")
        expect(item_image.height).to eq(100)
        expect(item_image.width).to eq(50)
        expect(item_image.type).to eq(:small)
      end
    end
  end
end
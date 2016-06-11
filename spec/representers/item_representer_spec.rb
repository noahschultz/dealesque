  require 'spec_helper_without_rails'

describe ItemRepresenter do
  context "when representing" do
    let(:item) { Item.new(
        id: "A123456", title: "Ulysses", url: "http://amazon", group: "Books", more_offers_url: "http://amazon/offers",
        list_price: Price.new,
        images: {small: ItemImage.new, large: ItemImage.new},
        offers: [Offer.new(merchant: "amazon"), Offer.new(merchant: "com")]
    )}

    context "to JSON" do
      it "represents properties" do
        names = %({"id":"A123456","title":"Ulysses","url":"http://amazon","group":"Books","more_offers_url":"http://amazon/offers"})
        expect(ItemRepresenter.new(item).to_json).to be_json_eql(names).excluding(:images).excluding(:offers).excluding(:list_price)
      end

      it "represents list price" do
        json_representation = ItemRepresenter.new(item).to_json
        expect(json_representation).to have_json_path("list_price")
      end

      it "represents images" do
        json_representation = ItemRepresenter.new(item).to_json
        expect(json_representation).to have_json_path("images")
        expect(json_representation).to have_json_path("images/small")
        expect(json_representation).to have_json_path("images/large")
      end

      it "represents offers" do
        json_representation = ItemRepresenter.new(item).to_json
        expect(json_representation).to have_json_path("offers")
        expect(json_representation).to have_json_size(2).at_path("offers")
      end
    end
  end

  context "when consuming" do
    context "from JSON" do
      let(:json) { %({"id":"A123456","title":"Ulysses","url":"http://amazon","group":"Books","more_offers_url":"http://amazon/offers","list_price":{},"images":{"small":{},"large":{}},"offers":[{}]}) }

      it "consumes properties" do
        item = Item.new
        ItemRepresenter.new(item).from_json(json)
        expect(item.id).to eq("A123456")
        expect(item.title).to eq("Ulysses")
        expect(item.url).to eq("http://amazon")
        expect(item.group).to eq("Books")
        expect(item.more_offers_url).to eq("http://amazon/offers")
      end

      it "consumes list price" do
        item = Item.new
        ItemRepresenter.new(item).from_json(json)
        expect(item.list_price).to be_a_kind_of(Price)
      end

      it "consumes images" do
        item = Item.new
        ItemRepresenter.new(item).from_json(json)
        expect(item.images.size).to eq(2)
        expect(item.images[:small]).not_to eq(nil)
        expect(item.images[:small]).to be_a_kind_of(ItemImage)
      end

      it "consumes offers" do
        item = Item.new
        ItemRepresenter.new(item).from_json(json)
        expect(item.offers.size).to eq(1)
        expect(item.offers.first).to be_a_kind_of(Offer)
        expect(item.offers.first.item).to eq(item)
      end
    end
  end
end
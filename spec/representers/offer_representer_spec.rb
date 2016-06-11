require 'spec_helper_without_rails'

describe OfferRepresenter do
  context "when representing" do
    let(:offer) { Offer.new(price: Price.new, merchant: 'Amazon', condition: Condition::USED) }

    context "to JSON" do
      it "represents properties" do
        names = %({"price":{"currency":"USD","fractional":0},"merchant":"Amazon","condition":"used"})
        expect(OfferRepresenter.new(offer).to_json).to be_json_eql(names)
      end
    end
  end

  context "when consuming" do
    context "from JSON" do
      let(:json) { %({"price":{},"merchant":"Amazon","condition":"used"}) }

      it "consumes properties" do
        offer = Offer.new
        OfferRepresenter.new(offer).from_json(json)
        expect(offer.price).to be_a_kind_of(Price)
        expect(offer.merchant).to eq("Amazon")
        expect(offer.condition).to eq(Condition::USED)
      end
    end
  end
end
require 'spec_helper_without_rails'

describe PriceRepresenter do
  context "when representing" do
    let(:price) { Price.new(fractional: 1023, currency: :usd) }

    context "to JSON" do
      it "represents properties" do
        names = %({"fractional":1023,"currency":"USD"})
        expect(PriceRepresenter.new(price).to_json).to be_json_eql(names)
      end
    end
  end

  context "when consuming" do
    context "from JSON" do
      let(:json) { %({"fractional":1023,"currency":"USD"}) }

      it "consumes properties" do
        price = Price.new
        PriceRepresenter.new(price).from_json(json)
        expect(price.fractional).to eq(1023)
        expect(price.currency_as_string).to eq("USD")
        expect(price.symbol).to eq("$")
      end
    end
  end
end
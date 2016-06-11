# encoding: UTF-8
require 'spec_helper_without_rails'

describe Price do
  context "when representing" do
    it "has amount and currency" do
      expect(Price.new(fractional: 9999, currency: :eur).to_s).to eq("€99,99")
    end

    it "places symbol in correct place" do
      expect(Price.new(fractional: 9999, currency: :sek).to_s).to eq("99,99 kr")
    end
  end

  context "when comparing" do
    let(:first) { Price.new(fractional: 10, currency: :usd) }
    let(:second) { Price.new(fractional: 10, currency: :usd) }

    it "compares prices with the same amount as the same" do
      expect(first == second).to eq(true)
    end
  end

  context "with price not available constant" do
    it "has zero value" do
      expect(Price::NOT_AVAILABLE.amount).to eq(0)
    end

    it "has specific representation" do
      expect(Price::NOT_AVAILABLE.to_s).to eq("N/A")
    end
  end

  context "when initializing" do
    context "without supplied attributes" do
      it "requires attribute hash" do
        expect { Price.new(nil) }.to raise_error(ArgumentError)
      end
    end

    context "with supplied attributes" do
      let(:attributes) { {fractional: 9999, currency: Money::Currency.new(:usd)} }
      let(:subject) { Price.new(attributes) }

      it "fills up from supplied attributes" do
        attributes.each do |attribute, value|
          expect(subject.public_send(attribute)).to eq(value)
        end
      end
    end
  end
end
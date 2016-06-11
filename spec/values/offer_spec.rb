require 'spec_helper_without_rails'

describe Offer do
  context "with attributes" do
    %w{id price merchant condition item}.each do |property|
      it "has #{property}" do
        expect(subject).to respond_to(property)
        expect(subject).to respond_to("#{property}=")
      end
    end

    it "defaults to Amazon.com for merchant" do
      expect(subject.merchant).to eq(Offer::MERCHANT_AMAZON_COM)
    end
  end

  context "when recognizing if it is from Amazon.com" do
    it "is not when merchant is not Amazon.com" do
      subject.stub(:merchant).and_return("someone")
      expect(subject.is_amazon?).to eq(false)
    end

    it "is when merchant is Amazon.com" do
      subject.stub(:merchant).and_return(Offer::MERCHANT_AMAZON_COM)
      expect(subject.is_amazon?).to eq(true)
    end
  end

  context "when comparing" do
    let(:item) { Item.new }
    let(:first) { Offer.new(item: item, price: 100, merchant: "amazon", condition: Condition::NEW) }
    let(:second) { Offer.new(item: item, price: 100, merchant: "amazon", condition: Condition::NEW) }

    it "compares offers with the same item, price, merchant and condition as the same" do
      expect(first == second).to eq(true)
    end
  end

  context "when initializing" do
    context "without supplied attributes" do
      it "requires attribute hash" do
        expect { Offer.new(nil) }.to raise_error(ArgumentError)
      end
    end

    context "with supplied attributes" do
      let(:attributes) { {id: 1, price: Price.new, merchant: "Amazon", condition: Condition::NEW, item: Item.new} }
      let(:subject) { Offer.new(attributes) }

      it "fills up from supplied attributes" do
        attributes.each do |attribute, value|
          expect(subject.public_send(attribute)).to eq(value)
        end
      end
    end
  end
end
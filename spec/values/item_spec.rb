require 'spec_helper_without_rails'

class MockOfferWithItem
  Surrogate.endow self
  define_accessor(:item)
  define_accessor(:condition)
  define_accessor(:price)

  def comparison_token
    "#{price} #{condition}"
  end
end

describe MockOfferWithItem do
  it "is a subset of Offer" do
    expect(Offer).to substitute_for(MockOfferWithItem, subset: true)
  end
end

describe Item do
  context "with attributes" do
    %w{id title url group list_price images offers more_offers_url}.each do |property|
      it "has #{property}" do
        expect(subject).to respond_to(property)
        expect(subject).to respond_to("#{property}=")
      end
    end

    context "with images" do
      let(:subject) { item = Item.new; item.images = {"small" => ItemImage.new}; item }

      it "coerces keys to symbol" do
        expect(subject.images.keys).to eq([:small])
      end
    end

    context "with offers" do
      let(:offer) { MockOfferWithItem.new }
      let(:subject) { Item.new }

      context "when returning best offers" do
        let(:subject) { item = Item.new; item.offers = [offer]; item }

        it "has best offer per condition" do
          offer.should_receive(:condition).and_return(Condition::NEW)
          expect(subject.best_offer(Condition::NEW)).to eq(offer)
        end

        it "filters best offer by condition" do
          offer.should_receive(:condition).and_return(Condition::USED)
          expect(subject.best_offer(Condition::NEW)).to eq(nil)
        end
      end

      context "when declaring" do
        it "sets offer item to self" do
          subject.offers = [offer]
          expect(subject.offers.first.item).to eq(subject)
        end

        it "does not duplicate offers" do
          subject.offers = [offer, offer, offer]
          expect(subject.offers.size).to eq(1)
        end

        it "sorts offers by price" do
          cheaper = MockOfferWithItem.new
          cheaper.price = 10
          expensive = MockOfferWithItem.new
          expensive.price = 20
          subject.offers = [expensive, cheaper]
          expect(subject.offers.map(&:price).first).to eq(10)
        end
      end

      context "when appending offers" do
        let(:offer_to_append) { MockOfferWithItem.new }

        it "appends to existing offers" do
          subject.append_offers([offer_to_append])
          expect(subject.offers.size).to eq(1)
        end

        it "appended offers reference item" do
          subject.append_offers([offer_to_append])
          expect(offer_to_append.item).to eq(subject)
        end

        it "does not duplicate offers" do
          10.times { subject.append_offers([offer_to_append]) }
          expect(subject.offers.size).to eq(1)
        end

        it "sorts offers by price" do
          cheaper = MockOfferWithItem.new
          cheaper.price = 10
          expensive = MockOfferWithItem.new
          expensive.price = 20
          subject.offers = [expensive, cheaper]
          expect(subject.offers.map(&:price).first).to eq(10)
        end
      end

      context "when calculating if list price is discounted" do
        it "is not discounted when no best new offer is present" do
          subject.stub(:best_offer).and_return(nil)
          expect(subject.list_price_discounted?).to eq(false)
        end

        it "is not discounted when best new offer is not from amazon" do
          best_new_offer = Offer.new
          best_new_offer.stub(:is_amazon?).and_return(false)
          subject.stub(:best_offer).and_return(best_new_offer)
          expect(subject.list_price_discounted?).to eq(false)
        end

        it "is not discounted when best new offer is from amazon but the offer price is not smaller" do
          best_new_offer = Offer.new
          best_new_offer.stub(:price).and_return(200)
          best_new_offer.stub(:is_amazon?).and_return(true)
          subject.stub(:list_price).and_return(100)
          subject.stub(:best_offer).and_return(best_new_offer)
          expect(subject.list_price_discounted?).to eq(false)
        end

        it "is discounted when best new offer is from amazon and the offer price is smaller" do
          best_new_offer = Offer.new
          best_new_offer.stub(:price).and_return(100)
          best_new_offer.stub(:is_amazon?).and_return(true)
          subject.stub(:list_price).and_return(200)
          subject.stub(:best_offer).and_return(best_new_offer)
          expect(subject.list_price_discounted?).to eq(true)
        end
      end
    end
  end

  context "when comparing" do
    let(:first) { Item.new(id: "A123456") }
    let(:second) { Item.new(id: "A123456") }

    it "compares items with the same ID as the same" do
      expect(first == second).to eq(true)
    end
  end

  context "when initializing" do
    context "with images" do
      let(:attributes) { {images: {"thumbnail" => ItemImage.new}} }
      let(:subject) { Item.new(attributes) }

      it "coerces keys to symbol" do
        expect(subject.images.keys).to eq([:thumbnail])
      end
    end

    context "with defaults" do
      {id: "", title: "", url: "", group: "", list_price: Price::NOT_AVAILABLE, images: {}, offers: [], more_offers_url: ""}.each do |property, default_value|
        it "has defaults #{property} to '#{default_value}'" do
          expect(subject.public_send(property)).to eq(default_value)
        end
      end
    end

    context "without supplied attributes" do
      it "requires attribute hash" do
        expect { Item.new(nil) }.to raise_error(ArgumentError)
      end
    end

    context "with supplied attributes" do
      let(:attributes) { {id: 1, title: "Shoulda coulda woulda", url: "http://some.url", group: "book", list_price: Price.new, images: {}, offers: [], more_offers_url: "http://more_offers.url"} }
      let(:subject) { Item.new(attributes) }

      it "fills up from supplied attributes" do
        attributes.each do |attribute, value|
          expect(subject.public_send(attribute)).to eq(value)
        end
      end
    end
  end
end
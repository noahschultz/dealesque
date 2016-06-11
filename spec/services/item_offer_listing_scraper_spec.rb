require 'spec_helper_without_rails'

class MockItemWithMoreOffersUrl
  Surrogate.endow self
  define(:initialize) { |args| @more_offers_url = args[:more_offers_url] }
  define_reader(:more_offers_url)
end

describe MockItemWithMoreOffersUrl do
  it "is a subset of Item" do
    expect(Item).to substitute_for(MockItemWithMoreOffersUrl, subset: true)
  end
end

class MockPickItem
  Surrogate.endow self
  define(:on_offers_scrapped_for) { |item, offers| }
end

describe MockPickItem do
  it "is a subset of PickItem" do
    expect(PickItem).to substitute_for(MockPickItem, subset: true)
  end
end

describe ItemOfferListingScraper do
  context "when scraping for item offers" do
    let(:item) { MockItemWithMoreOffersUrl.new(more_offers_url: "http://www.amazon.com/gp/offer-listing/0321584104%3FSubscriptionId%3DAKIAIAPIAMDJ5EGZIPJQ%26tag%3Ddealesque-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3D0321584104") }
    let(:offers) {
      VCR.use_cassette("scrap_all_item_offers") do
        subject.scrape_offers_for(item)
      end
    }

    it "returns empty array if invalid more offers url" do
      item.stub(more_offers_url: "")
      expect(offers).to eq([])
    end

    it "scrapes all available offers" do
      expect(offers.size).to eq(15)
    end

    it "scrapes id" do
      expect(offers.first.id).to eq("gx9RUyr8erVDxRK0WfSmbZbH7kGHzYXWexfFhm40M%2BZVIPnC8670b%2BhqFrjF%2FufMap3xxfz1nfi%2FQ5HCKCSfv6y2upuLvVL6RxtiW7xuzNWAdHT3yUQ6YDF2Xqiw6Njj83qQL7FMevpmHKEm4M944g%3D%3D")
    end

    it "scrapes merchant" do
      expect(offers.first.merchant).to eq("goodwillofwct")
    end

    it "scrapes condition" do
      expect(offers.first.condition).to eq(:used)
    end

    it "scrapes prices" do
      price = offers.first.price
      expect(price.amount).to eq(21.23)
      expect(price.currency.to_s).to eq("USD")
      expect(price.to_s).to eq("$21.23")
    end

    it "notifies about offers scrapped" do
      listener = MockPickItem.new
      subject.add_listener(listener)
      listener.should_receive(:on_offers_scrapped_for).with(subject, item, offers)
    end
  end
end
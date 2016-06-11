require 'spec_helper_without_rails'

describe PickItem do
  context "when picking" do
    let(:item) { Item.new }
    let(:picked_items_container) { PickedItems.new }
    let(:item_offer_listing_scraper) { stub(ItemOfferListingScraper).as_null_object }
    let(:subject) { PickItem.new(picked_items_container, item_offer_listing_scraper) }

    it "stores item into picked item container" do
      item_offer_listing_scraper.should_receive(:scrape_offers_for)
      subject.pick(item)
      expect(picked_items_container.include?(item)).to eq(true)
    end

    it "triggers scraping of additional item offers" do
      item_offer_listing_scraper.should_receive(:subscribe).with(subject)
      item_offer_listing_scraper.should_receive(:scrape_offers_for)
      subject.pick(item)
    end

    it "appends additional offers to item upon appropriate event" do
      subject.on_offers_scrapped_for(item, Array.new(10) {|index| Offer.new(price: index * 10)})
      expect(item.offers.size).to eq(10)
    end

    it "notifies about offers added to item" do
      listener = stub
      listener.should_receive(:on_offers_added_to).with(item)
      subject.subscribe(listener)
      subject.on_offers_scrapped_for(item, Array.new(10) {|index| Offer.new(price: index * 10)})
    end
  end

  context "when initializing" do
    it "requires picked items container" do
      expect { PickItem.new(nil) }.to raise_error(ArgumentError)
    end

    it "requires add scraped item offers to item if defined" do
      expect { PickItem.new(stub, nil) }.to raise_error
    end
  end
end
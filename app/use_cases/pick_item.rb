require_relative '../services/item_offer_listing_scraper'

class PickItem
  include Wisper

  def initialize(picked_items_container, item_offer_listing_scraper = ItemOfferListingScraper.new)
    raise ArgumentError.new("Missing picked items container") unless picked_items_container
    raise ArgumentError.new("Item offer listing scraper must be defined") unless item_offer_listing_scraper

    @picked_items_container = picked_items_container

    @item_offer_listing_scraper = item_offer_listing_scraper
    @item_offer_listing_scraper.subscribe(self)
  end

  def pick(item)
    @picked_items_container.add(item)
    @item_offer_listing_scraper.scrape_offers_for(item)
    item
  end

  def on_offers_scrapped_for(item, scraped_offers)
    item.append_offers(scraped_offers)
    publish(:on_offers_added_to, item)
    item
  end
end

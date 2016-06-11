require 'uri'
require 'nokogiri'
require 'mechanize'
require 'money'
require 'wisper'

class ItemOfferListingScraper
  include AmazonParser
  include Wisper

  # TODO scrape in background, it is too slow for the user to wait
  def scrape_offers_for(item)
    return [] unless valid_offers_url?(item.more_offers_url)
    root = Nokogiri::HTML(get_more_offers_page(item.more_offers_url))
    scraped_offers = scrape_offers(root)
    publish(:on_offers_scrapped_for, item, scraped_offers)
    scraped_offers
  end

  private

  def valid_offers_url?(more_offers_url)
    (more_offers_url =~ URI::regexp) != nil
  end

  def get_more_offers_page(more_offers_url)
    agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    page = agent.get(more_offers_url)
    page.content.strip
  end

  def scrape_offers(node)
    node.css('div.resultsset tbody.result').map do |offer_node|
      create_offer_from(offer_node)
    end
  end

  def create_offer_from(node)
    attributes = {}
    attributes[:id] = parse_value(node, './/form/input[@name = "offeringID.1"]/@value')
    attributes[:merchant] = parse_value(node, './/div[@class = "seller"]/a/b')
    attributes[:condition] = Condition.from(parse_value(node, './/div[@class = "condition"]').gsub("\n", " ").strip)
    attributes[:price] = create_price_from(node.xpath('.//span[@class = "price"]').first)
    Offer.new(attributes)
  end

  def create_price_from(node)
    return unless node
    attributes = {}
    Money.assume_from_symbol = true
    price = Money.parse(node.content)
    attributes[:fractional] = price.fractional
    attributes[:currency] = price.currency
    Price.new(attributes)
  end
end
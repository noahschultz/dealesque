class Item
  include Comparable

  attr_accessor :id, :title, :url, :group, :list_price, :more_offers_url
  attr_reader :images, :offers

  def initialize(attributes = {})
    raise ArgumentError.new("Missing attributes") unless attributes

    {id: "", title: "", url: "", group: "", list_price: Price::NOT_AVAILABLE, images: {}, offers: [], more_offers_url: ""}.each do |property, default_value|
      send("#{property}=", attributes[property] || default_value)
    end

    coerce_images_keys_to_symbol
  end

  def <=>(other)
    id <=> other.id
  end

  def images=(images)
    @images = images
    coerce_images_keys_to_symbol
  end

  def offers=(offers)
    @offers = offers.each { |offer| offer.item = self }
    remove_duplicate_offers
    sort_offers_by_price
    @offers
  end

  def append_offers(offers)
    @offers += offers.each { |offer| offer.item = self }
    remove_duplicate_offers
    sort_offers_by_price
    @offers
  end

  def best_offer(condition)
    @offers.find { |offer| offer.condition == condition }
  end

  def list_price_discounted?
    best_new_offer = best_offer(Condition::NEW)
    return false unless best_new_offer
    best_new_offer.is_amazon? && best_new_offer.price < list_price
  end

  private

  def remove_duplicate_offers
    @offers.uniq! { |offer| offer.comparison_token }
  end

  def sort_offers_by_price
    @offers.sort! { |offer, other| offer.price <=> other.price }
  end

  # TODO solve this in roar / representable
  # coercion in roar causes problems for collections:
  #   * all properties must be coerced (those that aren't are skipped)
  #   * all the chain must use coercion
  #   * hashes can't be serialized
  def coerce_images_keys_to_symbol
    coerced = {}
    @images.each { |type, image| coerced[type.to_sym] = image }
    @images = coerced
  end
end
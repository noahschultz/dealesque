class FindBestOffers
  def for_picked_items(picked_items)
    raise ArgumentError.new("Missing picked items") unless picked_items

    return [] if picked_items.empty?

    all_offers = collect_offers(picked_items)
    by_merchant = all_offers.group_by(&:merchant)
    by_merchant.values.min_by {|offers| offers.map(&:price).map(&:amount).reduce(&:+)}
  end

  private

  def collect_offers(picked_items)
    picked_items.collect do |picked_item|
      by_merchant = picked_item.offers.group_by(&:merchant)
      by_merchant.values.collect { |offers| take_minimum_offer(offers)}
    end.flatten
  end

  def take_minimum_offer(offers)
    offers.min_by {|offer| offer.price.amount}
  end
end
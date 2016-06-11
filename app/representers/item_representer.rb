require 'roar/representer'
require 'roar/representer/json'

require_relative 'price_representer'
require_relative 'offer_representer'
require_relative 'item_image_representer'

class ItemRepresenter < Representable::Decorator
  include Roar::Representer::JSON

  property :id
  property :title
  property :url
  property :group
  property :more_offers_url
  property :list_price, class: Price, decorator: PriceRepresenter
  hash :images, class: ItemImage, decorator: ItemImageRepresenter
  collection :offers, class: Offer, decorator: OfferRepresenter
end
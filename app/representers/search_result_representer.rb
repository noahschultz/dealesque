require 'roar/representer'
require 'roar/representer/json'

require_relative 'item_representer'

class SearchResultRepresenter < Representable::Decorator
  include Roar::Representer::JSON

  property :search_terms
  collection :items, class: Item, decorator: ItemRepresenter
end
require 'roar/representer'
require 'roar/representer/json'

require_relative 'item_representer'

class PickedItemsRepresenter < Representable::Decorator
  include Roar::Representer::JSON

  collection :items, class: Item, decorator: ItemRepresenter
end
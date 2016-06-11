require 'roar/representer'
require 'roar/representer/json'

require_relative 'price_representer'

class OfferRepresenter < Representable::Decorator
  include Roar::Representer::JSON

  property :id
  property :price, class: Price, decorator: PriceRepresenter
  property :merchant
  property :condition, setter: lambda { |val, args| self.condition = Condition.from(val) }
end
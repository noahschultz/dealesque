require 'roar/representer'
require 'roar/representer/json'

class ItemImageRepresenter < Representable::Decorator
  include Roar::Representer::JSON

  property :url
  property :height
  property :width
  property :type
end
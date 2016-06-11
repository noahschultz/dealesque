require 'forwardable'

class PickedItems
  extend Forwardable
  def_delegators :@items, :size, :include?, :delete, :empty?, :each, :each_with_index, :map, :collect
  alias_method :remove, :delete
  attr_accessor :items # needed for roar

  def initialize
    @items = []
  end

  # TODO if item quantity is needed, add it as behaviour to item using a module
  def add(item)
    @items << item unless include?(item)
  end
end
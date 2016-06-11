require 'forwardable'

class UnpickItem
  extend Forwardable
  def_delegators :@picked_items_container, :remove
  alias_method :unpick, :remove

  def initialize(picked_items_container)
    raise ArgumentError.new("Missing picked items container") unless picked_items_container
    @picked_items_container = picked_items_container
  end
end

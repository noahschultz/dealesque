class CartController < ApplicationController
  before_filter :retrieve_picked_items_from_session

  def create
    create_cart = CreateAmazonCart.new(AmazonClient.new(AMAZON_CREDENTIALS), AmazonCartResponseParser.new)
    cart = create_cart.with_picked_items(@picked_items)
    redirect_to cart.purchase_url
  end

  private

  # TODO this is used in PickedItemsController too, try to merge
  def retrieve_picked_items_from_session
    create_empty_picked_items
    PickedItemsRepresenter.new(@picked_items).from_json(session[:picked_items]) if session[:picked_items]
  end

  def create_empty_picked_items
    @picked_items = PickedItems.new
  end
end

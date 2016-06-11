class CreateAmazonCart
  def initialize(amazon_client, amazon_cart_response_parser)
    raise ArgumentError.new("Missing Amazon Client") unless amazon_client
    raise ArgumentError.new("Missing Amazon Cart Response Parser") unless amazon_cart_response_parser
    @amazon_client = amazon_client
    @amazon_cart_response_parser = amazon_cart_response_parser
  end

  def with_picked_items(picked_items)
    @amazon_cart_response_parser.parse(@amazon_client.create_cart_with(picked_items))
  end
end
class SearchAmazon
  def initialize(amazon_client, amazon_search_response_parser)
    raise ArgumentError.new("Missing Amazon Client") unless amazon_client
    raise ArgumentError.new("Missing Amazon Search Response Parser") unless amazon_search_response_parser
    @amazon_client = amazon_client
    @amazon_search_response_parser = amazon_search_response_parser
  end

  def with_keywords(keywords)
    @amazon_search_response_parser.parse(@amazon_client.search_with_keywords(keywords))
  end
end
require 'spec_helper_without_rails'
require 'vacuum'

describe "create amazon cart golden path" do
  let(:credentials) { YAML::load(File.open("config/amazon.yml"))["test"] }

  let(:cart_matcher) {
    lambda do |new_request, saved_request|
      new_items = new_request.uri[/Item(.*)Operation=.*/, 1]
      saved_items = saved_request.uri[/Item(.*)Operation=.*/, 1]
      new_items == saved_items
    end
  }

  it "adds the items to cart" do
    client = AmazonClient.new(credentials)
    create_cart = CreateAmazonCart.new(client, AmazonCartResponseParser.new)
    picked_items = PickedItems.new
    picked_items.add(Item.new(id: '0321721330'))
    picked_items.add(Item.new(id: 'B008VHMWMI'))
    VCR.use_cassette("create_amazon_cart_adds_the_items_to_cart", match_requests_on: [:method, cart_matcher]) do
      cart = create_cart.with_picked_items(picked_items)
      expect(cart).to be_a(Cart)
      expect(cart.purchase_url).to match(/https:\/\/www.amazon.com\/gp\/cart\/.*associate-id=#{credentials["tag"]}.*/)
    end
  end
end
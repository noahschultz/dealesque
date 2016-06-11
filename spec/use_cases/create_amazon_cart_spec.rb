require 'spec_helper_without_rails'

describe CreateAmazonCart do
  context "when searching by keywords" do
    let(:amazon_client) { AmazonClient.new(stub.as_null_object) }
    let(:amazon_cart_response_parser) { AmazonCartResponseParser.new }
    let(:subject) { CreateAmazonCart.new(amazon_client, amazon_cart_response_parser) }
    let(:picked_items) { stub }

    it "delegates create to amazon client" do
      amazon_client.should_receive(:create_cart_with).with(picked_items).and_return(stub.as_null_object)
      subject.with_picked_items(picked_items)
    end

    it "delegates response parsing to amazon cart response parser" do
      amazon_client.should_receive(:create_cart_with).with(picked_items)
      amazon_cart_response_parser.should_receive(:parse)
      subject.with_picked_items(picked_items)
    end
  end

  context "when initializing" do
    it "requires amazon client" do
      expect { SearchAmazon.new(nil, stub) }.to raise_error(ArgumentError)
    end

    it "requires amazon cart response parser" do
      expect { SearchAmazon.new(stub, nil) }.to raise_error(ArgumentError)
    end
  end
end
require 'spec_helper_without_rails'

describe SearchAmazon do
  context "when searching by keywords" do
    let(:amazon_client) { AmazonClient.new(stub.as_null_object) }
    let(:amazon_search_response_parser) { AmazonSearchResponseParser.new }
    let(:subject) { SearchAmazon.new(amazon_client, amazon_search_response_parser) }

    it "delegates search to amazon client" do
      amazon_client.should_receive(:search_with_keywords).with("Ulysses").and_return(stub.as_null_object)
      subject.with_keywords("Ulysses")
    end

    it "delegates response parsing to amazon search response parser" do
      amazon_client.should_receive(:search_with_keywords).and_return(stub.as_null_object)
      amazon_search_response_parser.should_receive(:parse)
      subject.with_keywords("Ulysses")
    end
  end

  context "when initializing" do
    it "requires amazon client" do
      expect { SearchAmazon.new(nil, stub) }.to raise_error(ArgumentError)
    end

    it "requires amazon search response parser" do
      expect { SearchAmazon.new(stub, nil) }.to raise_error(ArgumentError)
    end
  end
end
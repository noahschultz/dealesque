require 'spec_helper_without_rails'

describe AmazonClient do
  let(:subject) { AmazonClient.new(stub.as_null_object) }

  context "when searching" do
    context "with keywords" do
      let(:params) {{
          'Operation' => 'ItemSearch',
          'SearchIndex' => 'All',
          'ResponseGroup' => 'ItemAttributes,Offers,Images',
          'Keywords' => 'Odysseus'
      }}

      it "invokes search by keywords on provider" do
        subject.provider.should_receive(:get).with({query: params})
        subject.search_with_keywords('Odysseus')
      end
    end
  end

  context "when creating cart" do
    let(:picked_items) { [Item.new(id: 1), Item.new(id: 2)] }
    let(:params) {{
        'Operation' => 'CartCreate',
        'Item.0.ASIN' => '1',
        'Item.0.Quantity' => '1',
        'Item.1.ASIN' => '2',
        'Item.1.Quantity' => '1'
    }}

    it "invokes cart creating on provider" do
      subject.provider.should_receive(:get).with({query: params})
      subject.create_cart_with(picked_items)
    end
  end

  context "when initializing" do
    it "requires credentials" do
      expect { AmazonClient.new(nil) }.to raise_error(AmazonClientConfigurationError)
    end

    it "requires Amazon key" do
      expect { AmazonClient.new({"secret" => "secret", "tag" => "tag"}) }.to raise_error(AmazonClientConfigurationError)
    end

    it "requires Amazon secret" do
      expect { AmazonClient.new({"key" => "key", "tag" => "tag"}) }.to raise_error(AmazonClientConfigurationError)
    end

    it "requires Amazon tag" do
      expect { AmazonClient.new({"key" => "key", "secret" => "secret"}) }.to raise_error(AmazonClientConfigurationError)
    end
  end
end
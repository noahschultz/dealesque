require 'spec_helper_without_rails'

describe AmazonCartResponseParser do
  context "when parsing" do
    let(:response) { OpenStruct.new(body: File.read("spec/fixtures/amazon_api_responses/create_cart_response.xml")) }

    it "returns cart" do
      expect(subject.parse(stub.as_null_object)).to be_a_kind_of(Cart)
    end

    it "minds not the namespace" do
      response.body = response.body.gsub(/<CartCreateResponse>/, '<CartCreateResponse xmlns="exists">')
      expect(subject.parse(response)).to be_a_kind_of(Cart)
    end

    context "with cart" do
      let(:cart) { subject.parse(response) }

      it "has relevant data" do
        expect(cart.id).to eq("180-0911026-2735701")
        expect(cart.hmac).to eq("TGygeGB4gYnQtMzeeOxgsIBetKA=")
        expect(cart.encoded_hmac).to eq("TGygeGB4gYnQtMzeeOxgsIBetKA%3D")
        expect(cart.purchase_url).to eq("https://www.amazon.com/gp/cart/aws-merge.html?cart-id=180-0911026-2735701%26associate-id=dealesque-20%26hmac=TGygeGB4gYnQtMzeeOxgsIBetKA=%26SubscriptionId=AKIAIAPIAMDJ5EGZIPJQ%26MergeCart=False")
      end
    end
  end
end
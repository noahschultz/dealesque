require 'spec_helper_without_rails'

describe Cart do
  context "with attributes" do
    %w{id hmac encoded_hmac purchase_url}.each do |property|
      it "has #{property}" do
        expect(subject).to respond_to(property)
        expect(subject).to respond_to("#{property}=")
      end
    end
  end

  context "when initializing" do
    context "with defaults" do
      {id: "", hmac: "", encoded_hmac: "", purchase_url: ""}.each do |property, default_value|
        it "has defaults #{property} to '#{default_value}'" do
          expect(subject.public_send(property)).to eq(default_value)
        end
      end
    end

    context "without supplied attributes" do
      it "requires attribute hash" do
        expect { Cart.new(nil) }.to raise_error(ArgumentError)
      end
    end

    context "with supplied attributes" do
      let(:attributes) { {id: 1, hmac: "A456987456", encoded_hmac: "B456687456", purchase_url: "http://amazon"} }
      let(:subject) { Cart.new(attributes) }

      it "fills up from supplied attributes" do
        attributes.each do |attribute, value|
          expect(subject.public_send(attribute)).to eq(value)
        end
      end
    end
  end
end
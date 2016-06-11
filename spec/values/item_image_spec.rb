require 'spec_helper_without_rails'

describe ItemImage do
  context "with attributes" do
    %w{url height width type}.each do |property|
      it "has #{property}" do
        expect(subject).to respond_to(property)
        expect(subject).to respond_to("#{property}=")
      end
    end

    context "with type" do
      let(:subject) { item_image = ItemImage.new; item_image.type = "thumbnail"; item_image }

      it "coerces to symbol" do
        expect(subject.type).to eq(:thumbnail)
      end
    end
  end

  context "when initializing" do
    context "with type" do
      let(:attributes) { {type: "thumbnail"} }
      let(:subject) { ItemImage.new(attributes) }

      it "coerces to symbol" do
        expect(subject.type).to eq(:thumbnail)
      end
    end

    context "with defaults" do
      {url: "", height: 0, width: 0, type: :undefined}.each do |property, default_value|
        it "has defaults #{property} to '#{default_value}'" do
          expect(subject.public_send(property)).to eq(default_value)
        end
      end
    end

    context "without supplied attributes" do
      it "requires attribute hash" do
        expect { ItemImage.new(nil) }.to raise_error(ArgumentError)
      end
    end

    context "with supplied attributes" do
      let(:attributes) { {url: "http://some.url", height: 100, width: 100, type: :thumbnail} }
      let(:subject) { ItemImage.new(attributes) }

      it "fills up from supplied attributes" do
        attributes.each do |attribute, value|
          expect(subject.public_send(attribute)).to eq(value)
        end
      end
    end
  end
end
require 'spec_helper_without_rails'

describe AmazonSearchResponseParser do
  context "when parsing" do
    let(:response) { OpenStruct.new(body: File.read("spec/fixtures/amazon_api_responses/search_response_multiple_items.xml")) }

    it "returns search result" do
      expect(subject.parse(response)).to be_a_kind_of(SearchResult)
    end

    it "minds not the namespace" do
      response.body = response.body.gsub(/<ItemSearchResponse>/, '<ItemSearchResponse xmlns="exists">')
      expect(subject.parse(response)).to be_a_kind_of(SearchResult)
    end

    context "with search result" do
      it "has search terms" do
        expect(subject.parse(response).search_terms).to eq("Practical Object-Oriented Design in Ruby")
      end

      context "with items" do
        it "has all the items" do
          expect(subject.parse(response).items.size).to eq(9)
        end

        context "with regular item" do
          let(:item) { subject.parse(response).items.first }

          it "has relevant data" do
            expect(item.id).to eq("0321721330")
            expect(item.title).to eq("Practical Object-Oriented Design in Ruby: An Agile Primer (Addison-Wesley Professional Ruby Series)")
            expect(item.url).to eq("http://www.amazon.com/Practical-Object-Oriented-Design-Ruby-Addison-Wesley/dp/0321721330%3FSubscriptionId%3DAKIAIAPIAMDJ5EGZIPJQ%26tag%3Ddealesque-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0321721330")
            expect(item.group).to eq("Book")
            expect(item.more_offers_url).to eq("http://www.amazon.com/gp/offer-listing/0321721330%3FSubscriptionId%3DAKIAIAPIAMDJ5EGZIPJQ%26tag%3Ddealesque-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3D0321721330")
          end

          it "has list price" do
            expect(item.list_price.amount).to eq(39.99)
            expect(item.list_price.currency.to_s).to eq("USD")
            expect(item.list_price.to_s).to eq("$39.99")
          end

          it "has all the images" do
            expect(item.images.size).to eq(6)
          end

          context "with image" do
            let(:image) { item.images[:swatch] }

            it "has relevant data" do
              expect(image.url).to eq("http://ecx.images-amazon.com/images/I/51vkmxCfmRL._SL30_.jpg")
              expect(image.height).to eq(30)
              expect(image.width).to eq(23)
              expect(image.type).to eq(:swatch)
            end
          end
        end

        context "with item with offers" do
          let(:response) { OpenStruct.new(body: File.read("spec/fixtures/amazon_api_responses/search_response_single_item_with_multiple_image_sets.xml")) }
          let(:item) { subject.parse(response).items.first }

          it "has all the offers" do
            expect(item.offers.size).to eq(2)
          end

          context "with offer" do
            let(:offer) { item.offers.first }

            it "has relevant data" do
              expect(offer.id).to eq("Qko%2F4HCigNbXDDWsMJgO5nXT77Jal45yqlmvEM9UFSEXPZsMHfp7myLUd3Y6anKdUMwBdrqJgNBZG4CcqFgl5tDDJcpABYO%2BiwySbHFU1sjlWXKcUBAFgZbRlg8xVcaImXNLLsWeYrFMlF4TIQXFSA%3D%3D")
              expect(offer.merchant).to eq("RoyceBooks")
              expect(offer.condition).to eq(Condition::USED)
              expect(offer.price).to be_a_kind_of(Price)
            end

            context "with price" do
              let(:price) { offer.price }

              it "has relevant data" do
                expect(price.amount).to eq(23.00)
                expect(price.currency.to_s).to eq("USD")
                expect(price.to_s).to eq("$23.00")
              end
            end
          end
        end

        context "with item without offers" do
          let(:response) { OpenStruct.new(body: File.read("spec/fixtures/amazon_api_responses/search_response_single_item_without_offers.xml")) }
          let(:item) { subject.parse(response).items.first }

          it "doesn't throw an exception" do
            expect(item.offers.size).to eq(0)
          end
        end

        context "with item without images" do
          context "with image" do
            let(:response) { OpenStruct.new(body: File.read("spec/fixtures/amazon_api_responses/search_response_single_item_without_images.xml")) }
            let(:item) { subject.parse(response).items.first }

            it "has relevant data" do
              expect(item.images.size).to eq(0)
            end
          end
        end

        context "with item with multiple images" do
          context "with image" do
            let(:response) { OpenStruct.new(body: File.read("spec/fixtures/amazon_api_responses/search_response_single_item_with_multiple_image_sets.xml")) }
            let(:item) { subject.parse(response).items.first }
            let(:image) { item.images[:swatch] }

            it "has relevant data" do
              expect(image.url).to match(/.*41IDuwJXFCL.*/)
            end
          end
        end
      end
    end
  end
end
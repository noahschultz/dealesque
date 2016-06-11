require 'spec_helper_without_rails'

describe SearchResultRepresenter do
  context "when representing" do
    let(:search_result) { SearchResult.new(search_terms: "Ruby Book", items: [Item.new, Item.new]) }

    context "to JSON" do
      it "represents properties" do
        names = %({"search_terms":"Ruby Book"})
        expect(SearchResultRepresenter.new(search_result).to_json).to be_json_eql(names).excluding(:items)
      end

      it "represents items" do
        json_representation = SearchResultRepresenter.new(search_result).to_json
        expect(json_representation).to have_json_path("items")
        expect(json_representation).to have_json_size(2).at_path("items")
      end
    end
  end

  context "when consuming" do
    context "from JSON" do
      let(:json) { %({"search_terms":"Ruby Book","items":[{},{}]}) }

      it "consumes properties" do
        search_result = SearchResult.new
        SearchResultRepresenter.new(search_result).from_json(json)
        expect(search_result.search_terms).to eq("Ruby Book")
      end

      it "consumes items" do
        search_result = SearchResult.new
        SearchResultRepresenter.new(search_result).from_json(json)
        expect(search_result.items.size).to eq(2)
        search_result.items.each do |item|
          expect(item).to be_a_kind_of(Item)
        end
      end
    end
  end
end
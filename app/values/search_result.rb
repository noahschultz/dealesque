class SearchResult
  attr_accessor :search_terms, :items

  def initialize(attributes = {})
    raise ArgumentError.new("Missing attributes") unless attributes

    # TODO, use Sandy Metz style (2-3 options in the book, page 48+)
    {search_terms: "", items: []}.each do |property, default_value|
      send("#{property}=", attributes[property] || default_value)
    end
  end
end
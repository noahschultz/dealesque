require 'hashie/mash'
require 'crack/xml'

class AmazonSearchResponseParserCrackHashie
  def parse(response)
    data = Hashie::Mash.new(Crack::XML.parse(response.body))

    attributes = {}
    attributes[:search_terms] = parse_search_terms(data)
    attributes[:items] = parse_items(data)

    SearchResult.new(attributes)
  end

  private

  def parse_search_terms(data)
    keywords = data.ItemSearchResponse.OperationRequest.Arguments.Argument.find {|argument| argument.Name == 'Keywords'}
    keywords ? keywords.Value : ""
  end

  def parse_items(data)
    items_data = data.ItemSearchResponse.Items.Item
    if items_data.kind_of?(Array)
      items_data.map {|item_data| create_item_from(item_data)}
    else
      [create_item_from(items_data)]
    end
  end

  def create_item_from(data)
    attributes = {}
    attributes[:id] = data.ASIN
    attributes[:title] = data.ItemAttributes.Title
    attributes[:url] = data.DetailPageURL
    attributes[:group] = data.ItemAttributes.ProductGroup
    attributes[:images] = parse_item_images(data)
    Item.new(attributes)
  end

  def parse_item_images(data)
    return unless data.respond_to?(:ImageSets)

    image_set = data.ImageSets.ImageSet
    image_set = image_set.find { |image_set| image_set.Category == 'primary' } || image_set.first if image_set.kind_of?(Array)
    image_set.keys.select { |key| key =~ /.*Image/ }.inject(Hash.new) do |images, key|
      image = create_item_image_from(image_set.send(key), key)
      images[image.type] = image
      images
    end
  end

  def create_item_image_from(item_data, type)
    attributes = {}
    attributes[:url] = item_data.URL
    attributes[:height] = item_data.Height.to_i
    attributes[:width] = item_data.Width.to_i
    attributes[:type] = type.gsub("Image", "").downcase
    ItemImage.new(attributes)
  end
end
require 'yaml'
require 'asin'
require 'hashie'

class Item < ASIN::SimpleItem
  alias_method :id, :asin
end

amazon_credentials = Hashie::Mash.new(YAML::load(File.open('../../../config/amazon.yml'))['development'])
ASIN::Configuration.configure do |config|
  config.secret        = amazon_credentials.secret
  config.key           = amazon_credentials.key!
  config.associate_tag = amazon_credentials.tag
  #config.logger        = nil
  config.item_type     = Item
end

client = ASIN::Client.instance
#items = client.search_keywords 'Practical Object-Oriented Design in Ruby: An Agile Primer', {SearchIndex: 'All', ResponseGroup: 'ItemAttributes,Offers,Images'}
items = client.search Keywords: 'Practical Object-Oriented Design in Ruby: An Agile Primer', SearchIndex: 'All', ResponseGroup: 'ItemAttributes,Offers,Images'
book = items.first
puts "================================"
puts book.raw
puts "================================"
puts book.raw.ImageSets!.ImageSet!.Category
book.raw.ImageSets!.each do |image_set|
  puts '*************************'
  puts image_set.inspect
end
puts "================================"

cart = client.create_cart({:asin => '1430218150', :quantity => 1})

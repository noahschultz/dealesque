require 'nokogiri'
require 'open-uri'
require 'forwardable'
require 'csv'

UsedOffering = Struct.new(:seller, :price)

class Item
  include Enumerable
  extend Forwardable

  attr_reader :id, :title, :used_offerings

  def_delegators :@used_offerings, :each, :<<

  def initialize(id)
    @id = id
    parse_from_amazon_data
  end

  private

  def parse_from_amazon_data
    used_page = Nokogiri::HTML(open("http://www.amazon.com/gp/offer-listing/#{@id}/ref=dp_olp_used?ie=UTF8&condition=used"))
    @title = used_page.search(".producttitle").first.content
    @used_offerings = used_page.search(".result").map do |offering|
      seller = offering.search(".seller a b").first || "hidden"
      seller = seller.content.capitalize.gsub(/[_-]/, " ").strip unless seller == "hidden"
      UsedOffering.new(
        seller,
        offering.search(".price").first.content
      )
    end
  end
end

items = ARGV.map { |id| Item.new(id) }

sellers = items.map do |item|
  item.used_offerings.map { |used_offering| used_offering.seller }
end.flatten.uniq.sort

data = sellers.map do |seller|
  [seller, items.map do |item|
    used_offering = item.used_offerings.select { |used_offering| used_offering.seller == seller }.first
    next nil unless used_offering
    used_offering.price
  end].flatten
end

data.each do |row|
  puts row if row.compact.size == items.size + 1
end

exit

# export all used offerings data as CSV

header = ["Sellers:"] + items.map { |item| item.id }

csv = CSV.generate do |csv|
  csv << header
  data.each { |row| csv << row }
end

puts "Matching used offerings for items:"
items.each { |item| puts "  #{item.id}: #{item.title}" }
puts csv

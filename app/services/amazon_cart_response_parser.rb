require 'nokogiri'

class AmazonCartResponseParser
  include AmazonParser

  def parse(response)
    root = Nokogiri::XML(response.body).remove_namespaces!

    attributes = {}
    attributes[:id] = parse_value(root, '//CartId')
    attributes[:hmac] = parse_value(root, '//HMAC')
    attributes[:encoded_hmac] = parse_value(root, '//URLEncodedHMAC')
    attributes[:purchase_url] = parse_value(root, '//PurchaseURL')

    Cart.new(attributes)
  end
end
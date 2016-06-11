require 'nokogiri'

module AmazonParser
  def parse_value(node, path, apply_method = nil)
    nodes = node.xpath(path)
    if nodes.first
      value = nodes.first.content
      value = value.respond_to?(:strip) ? value.strip : value
      apply_method ? value.send(apply_method) : value
    end
  end
end
require_relative '../../../spec/spec_helper_without_rails'
require_relative 'amazon_search_response_parser_crack_hashie'

response = OpenStruct.new(body: File.read('spec/fixtures/amazon_api_responses/search_response_multiple_items.xml'))
result = AmazonSearchResponseParser.new.parse(response)
tests_to_run = 100

start = Time.now
tests_to_run.times { AmazonSearchResponseParser.new.parse(response) }
nokogiri = Time.now - start

start = Time.now
tests_to_run.times { AmazonSearchResponseParserCrackHashie.new.parse(response) }
crack_hashie = Time.now - start

puts "Test results parsing Amazon response with #{result.items.size} items in #{tests_to_run} consecutive runs"
puts "Nokogiri: #{nokogiri} seconds"
puts "Crack & Hashie: #{crack_hashie} seconds"

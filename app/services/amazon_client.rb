class AmazonClientConfigurationError < StandardError; end

class AmazonClient
  attr_reader :provider

  class << self
    def validate_credentials(credentials)
      raise AmazonClientConfigurationError.new("Missing Amazon credentials") unless credentials

      errors = []
      errors << "Missing Amazon key" unless credentials["key"]
      errors << "Missing Amazon secret" unless credentials["secret"]
      errors << "Missing Amazon tag" unless credentials["tag"]

      raise AmazonClientConfigurationError.new(errors.join("\n")) if errors.size > 0
    end
  end

  def initialize(credentials)
    self.class.validate_credentials(credentials)
    @provider = Vacuum.new.tap { |provider| provider.configure(credentials) }
  end

  def create_cart_with(picked_items)
    params = {'Operation' => 'CartCreate'}
    picked_items.each_with_index do |item, index|
      params["Item.#{index}.ASIN"] = item.id.to_s
      params["Item.#{index}.Quantity"] = 1.to_s
    end
    call(params)
  end

  def search_with_keywords(keywords)
    call(
        'Operation' => 'ItemSearch',
        'SearchIndex' => 'All',
        'ResponseGroup' => 'ItemAttributes,Offers,Images',
        'Keywords' => keywords
    )
  end

  private

  def call(params)
    provider.get(query: params)
  end
end
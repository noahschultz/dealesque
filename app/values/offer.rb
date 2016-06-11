class Offer
  include Comparable

  attr_accessor :id, :price, :merchant, :condition, :item

  MERCHANT_AMAZON_COM = 'Amazon.com'

  def initialize(attributes = {})
    raise ArgumentError.new("Missing attributes") unless attributes

    [:id, :price, :merchant, :condition, :item].each do |property|
      send("#{property}=", attributes[property])
    end

    @merchant ||= Offer::MERCHANT_AMAZON_COM
  end

  def <=>(other)
    comparison_token <=> other.comparison_token
  end

  def comparison_token
    "#{price} #{merchant} #{condition}"
  end

  def is_amazon?
    merchant == MERCHANT_AMAZON_COM
  end
end
class Cart
  attr_accessor :id, :hmac, :encoded_hmac, :purchase_url

  def initialize(attributes = {})
    raise ArgumentError.new("Missing attributes") unless attributes

    {id: "", hmac: "", encoded_hmac: "", purchase_url: ""}.each do |property, default_value|
      send("#{property}=", attributes[property] || default_value)
    end
  end
end
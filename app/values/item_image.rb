class ItemImage
  attr_accessor :url, :height, :width
  attr_reader :type

  def initialize(attributes = {})
    raise ArgumentError.new("Missing attributes") unless attributes

    {url: "", height: 0, width: 0, type: :undefined}.each do |property, default_value|
      send("#{property}=", attributes[property] || default_value)
    end

    coerce_type_to_symbol
  end

  def type=(type)
    @type = type
    coerce_type_to_symbol
  end

  private

  # TODO solve this in roar / representable
  # coercion in roar causes problems for collections:
  #   * all properties must be coerced (those that aren't are skipped)
  #   * all the chain must use coercion
  #   * hashes can't be serialized
  def coerce_type_to_symbol
    @type = @type.to_sym
  end
end

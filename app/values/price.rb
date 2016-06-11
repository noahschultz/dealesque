require 'forwardable'
require 'money'

class Price
  include Comparable

  extend Forwardable
  def_delegators :@money, :fractional, :amount, :currency, :currency_as_string, :to_f, :to_d, :symbol, :<=>, :to_money

  def initialize(attributes = {})
    raise ArgumentError.new("Missing attributes") unless attributes
    create_money(attributes[:fractional], attributes[:currency])
  end

  def fractional=(fractional)
    create_money(fractional, currency)
  end

  def currency=(currency)
    create_money(fractional, currency)
  end

  def to_s
    return "#{symbol}#{@money.to_s}" if currency.symbol_first?
    "#{@money.to_s} #{symbol}"
  end

  private

  def create_money(fractional, currency)
    @money = (currency ? Money.new(fractional, currency) : Money.new(fractional))
  end
end

Price::NOT_AVAILABLE = Price.new(fractional: 0)
class << Price::NOT_AVAILABLE
  def to_s
    "N/A"
  end
end
class GuestRate
  CHILD = '0.70'.freeze

  def self.calculate_child_price(base_price)
    (BigDecimal(base_price.to_s) * BigDecimal(CHILD)).floor
  end
end

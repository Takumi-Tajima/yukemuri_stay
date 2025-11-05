class Tax
  RATE = '1.10'.freeze

  def self.calculate_with_tax(amount)
    (BigDecimal(amount.to_s) * BigDecimal(RATE)).floor
  end
end

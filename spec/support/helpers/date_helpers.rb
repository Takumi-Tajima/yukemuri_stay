module DateHelpers
  def today
    Date.current
  end

  def tomorrow
    Date.current + 1.day
  end

  def days_from_now(n)
    Date.current + n.days
  end

  def days_ago(n)
    Date.current - n.days
  end
end

RSpec.configure do |config|
  config.include DateHelpers
end

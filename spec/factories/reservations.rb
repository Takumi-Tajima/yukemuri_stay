FactoryBot.define do
  factory :reservation do
    user { nil }
    room_type { nil }
    check_in_date { Faker::Date.forward(from: Date.current, days: 90) }
    nights { Faker::Number.between(from: 1, to: 5) }
    adults { Faker::Number.non_zero_digit }
    children { Faker::Number.non_zero_digit }
    total_amount { Faker::Number.between(from: 1, to: 999999) }
  end
end

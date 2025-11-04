FactoryBot.define do
  factory :room_availability do
    room_type { nil }
    date { Faker::Date.in_date_period }
    remaining_rooms { Faker::Number.between(from: 0, to: 50) }
  end
end

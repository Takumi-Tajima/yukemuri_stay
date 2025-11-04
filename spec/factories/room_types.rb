FactoryBot.define do
  factory :room_type do
    accommodation { nil }
    sequence(:name) { |n| "RoomType #{n}" }
    capacity { Faker::Number.non_zero_digit }
    base_price { Faker::Number.between(from: 1, to: 999999) }
    description { Faker::Lorem.sentence }
  end
end

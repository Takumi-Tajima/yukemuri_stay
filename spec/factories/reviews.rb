FactoryBot.define do
  factory :review do
    reservation { nil }
    user { nil }
    rating { Faker::Number.between(from: Review::MIN_RATING, to: Review::MAX_RATING) }
    comment { Faker::Lorem.paragraph }
  end
end

FactoryBot.define do
  factory :accommodation do
    sequence(:name) { |n| "Accommodation #{n}" }
    prefecture { Prefecture::ALL.values.sample }
    address { Faker::Address.full_address }
    phone_number { Faker::PhoneNumber.phone_number }
    accommodation_type { Accommodation::ACCOMMODATION_TYPE.sample }
    description { Faker::Lorem.sentence }
    published { false }
  end
end

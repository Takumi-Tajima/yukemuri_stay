FactoryBot.define do
  factory :administrator do
    email { Faker::Internet.unique.email }
    name { Faker::Name.name }
    password { 'password' }
  end
end

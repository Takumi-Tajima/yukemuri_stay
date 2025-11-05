FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    name { Faker::Name.name }
    password { 'password' }
    confirmed_at { Time.current }
  end
end

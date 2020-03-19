FactoryBot.define do
  factory :profile do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.middle_name }
    last_name { Faker::Name.last_name }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
    postal_code { Faker::Address.zip_code }
    city { Faker::Address.city }
    address { Faker::Address.street_address }
    is_confirmed { true }
  end
end

FactoryBot.define do
  factory :branch do
    name { Faker::Company.name }
    kind { Branch.kinds.keys.sample }
    address { Faker::Address.street_address }
    serial_num { SecureRandom.uuid }
  end
end

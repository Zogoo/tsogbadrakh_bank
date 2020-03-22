FactoryBot.define do
  factory :branch do
    name { Faker::Company.name }
    kind { Branch.kinds.keys.sample }
    address { Faker::Address.full_address }
    serial_num { SecureRandom.uuid }

    trait :atm do
      kind { :atm }
    end
  end
end

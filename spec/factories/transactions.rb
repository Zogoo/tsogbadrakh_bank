FactoryBot.define do
  factory :transaction do
    association :account, strategy: :build

    status { :created }
    amount { Faker::Number.number(digits: 10) }
    reciever { create(:account) }

    trait :transfer do
      type { Transfer.to_s }
    end
  end
end

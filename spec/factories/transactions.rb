FactoryBot.define do
  factory :transaction do
    association :account, strategy: :build

    status { :created }
    amount { Faker::Number.number(digits: 10) }
    receiver { create(:account) }
  end
end

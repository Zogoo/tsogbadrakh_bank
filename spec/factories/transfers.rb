FactoryBot.define do
  factory :transfer do
    association :account, strategy: :build

    type { Transfer.to_s }
    status { :created }
    amount { Faker::Number.number(digits: 10) }
    reciever { create(:account) }
  end
end

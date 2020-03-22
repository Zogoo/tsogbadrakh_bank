FactoryBot.define do
  factory :account do
    association :user, strategy: :build

    kind { Account.kinds.keys.sample }
    status { :active }
    balance { Faker::Number.number(digits: 10) }
    interest_rate { Faker::Number.number(digits: 2) }
    interest_period { Faker::Number.number(digits: 2) }

    trait :savings do
      kind { :savings }
    end
  
    trait :checking do
      kind { :savings }
    end
  end
end

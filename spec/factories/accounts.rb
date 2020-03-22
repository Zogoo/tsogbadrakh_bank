FactoryBot.define do
  factory :account do
    association :user, strategy: :build

    kind { Account.kinds.keys.sample }
    status { :active }
    lock_state { :unlocked }
    balance { Faker::Number.number(digits: 10) }
    interest_rate { Faker::Number.number(digits: 2) }
    interest_period { Faker::Number.number(digits: 2) }
    currency { %w[usd eur jpy grp].sample }

    trait :savings do
      kind { :savings }
    end
  
    trait :checking do
      kind { :checking }
    end
  end
end

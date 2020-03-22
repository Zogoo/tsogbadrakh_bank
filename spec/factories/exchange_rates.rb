FactoryBot.define do
  factory :exchange_rate do
    currency_from { %w[usd eur jpy grp].sample }
    currency_to { %w[usd eur jpy grp].sample }
    rate { Faker::Number.decimal(l_digits: 2) }
    added_at { Time.now }

    trait :usd_jpy do
      currency_from { 'usd' }
      currency_to { 'jpy' }
    end

    trait :usd_euro do
      currency_from { 'usd' }
      currency_to { 'eur' }
    end

    trait :eur_jpy do
      currency_from { 'eur' }
      currency_to { 'jpy' }
    end

    trait :usd_cny do
      currency_from { 'usd' }
      currency_to { 'cny' }
    end

    trait :eur_cny do
      currency_from { 'eur' }
      currency_to { 'cny' }
    end

    trait :eur_gbp do
      currency_from { 'eur' }
      currency_to { 'gbp' }
    end
  end
end

FactoryBot.define do
  factory :exchange_rate do
    from { %w[usd eur jpy grp].sample }
    to { %w[usd eur jpy grp].sample }
    rate { Faker::Number.decimal(l_digits: 2) }
    added_date { Time.now }
  end
end

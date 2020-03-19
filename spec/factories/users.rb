FactoryBot.define do
  factory :user do
    association :branch, strategy: :build
    profile { build(:profile) }

    uuid { SecureRandom.uuid }
    status { :active }
    is_confirmed { true }
    registration_date { 1.year.ago }

  end
end

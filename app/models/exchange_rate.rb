# frozen_string_literal: true

class ExchangeRate < ApplicationRecord
  scope :rate_inclusion, lambda { |from, to|
    where(currency_from: [from, to])
      .where(currency_to: [from, to])
      .order(added_at: :desc)
      .limit(1)
  }
end

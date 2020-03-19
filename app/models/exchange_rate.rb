# frozen_string_literal: true

class ExchangeRate < ApplicationRecord
  enum status: %i[current old]
end

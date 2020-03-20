# frozen_string_literal: true

class Transfer < Transaction
  validates :amount, numericality: { greater_than: 0 }
end

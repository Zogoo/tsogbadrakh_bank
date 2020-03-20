# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions
  has_many :received_transactions, class_name: :Transaction, foreign_key: :receiver_id

  enum kind: %i[checking savings]
  enum status: %i[created active blocked suspended disabled deleted]
  enum currency_type: { usd: 'usd', euro: 'eur', yen: 'jpy', pound: 'grp' }

  validates :kind, inclusion: { in: kinds.keys }, presence: true
  validates :status, inclusion: { in: statuses.keys }, presence: true

  validates :interest_rate, numericality: { greater_than: 0, less_than: 100 }
  validates :interest_period, numericality: { greater_than: 0 }

  def balance_as_float
    balance.to_f / 100
  end

  def interest_rate_as_float
    interest_rate.to_f / 100
  end

  def interest_period_by_year
    interest_period.to_f / 365
  end
end

# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions
  has_many :received_transactions, class_name: :Transaction, foreign_key: :receiver_id

  enum kind: %i[checking savings]
  enum status: %i[created active blocked suspended disabled deleted]
  enum currency_type: { usd: 'usd', euro: 'eur', yen: 'jpy', pound: 'grp' }

  validates :kind, inclusion: kinds.keys, presence: true
  validates :interest_rate, numericality: true
  validates :interest_period, numericality: true

  def float_balance
    balance.to_f / 100
  end
end

# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions
  has_many :received_transactions, class_name: :Transaction, foreign_key: :receiver_id

  enum kind: %i[checking savings]
  enum status: %i[created active blocked suspended disabled deleted]
  enum lock_state: %i[unlocked locked]
  enum currency_type: { usd: 'usd', euro: 'eur', yen: 'jpy', pound: 'grp' }

  validates :kind, inclusion: { in: kinds.keys }, presence: true
  validates :status, inclusion: { in: statuses.keys }, presence: true

  validates :interest_rate, numericality: { greater_than: 0, less_than: 100 }
  validates :interest_period, numericality: { greater_than: 0 }

  validates :lock_state, inclusion: { in: lock_states.keys }, presence: true

  before_update :check_lock_state

  def balance_as_float
    balance.to_f / 100
  end

  def interest_rate_as_float
    interest_rate.to_f / 100
  end

  def interest_period_by_year
    interest_period.to_f / 365
  end

  private

  def check_lock_state
    if lock_state_was == 'locked' && lock_state != 'unlocked'
      raise Bank::Error::FailedInternalProcess, 'This account is locked!. Please unlock first'
    end
  end
end

# frozen_string_literal: true

module TransferFunds
  module Processor
    include Bank::Error

    def process!(transaction)
      sender = transaction.account
      receiver = transaction.receiver
      amount = transaction.amount

      transfer_amount = if sender.currency != receiver.currency
                          ExchangeRateCalculator.calculate(
                            from: sender.currency,
                            to: receiver.currency,
                            amount: amount
                          )
                        else
                          amount
                        end
      # Block accounts
      sender.locked!
      receiver.locked!

      ActiveRecord::Base.transaction do
        sender_balance = sender.balance - amount
        receiver_balance = receiver.balance + transfer_amount
        sender.update!(balance: sender_balance, lock_state: :unlocked)
        receiver.update!(balance: receiver_balance, lock_state: :unlocked)
      end
    rescue StandardError => e
      # Leave log
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      # Unblock for any error
      sender.unlocked!
      receiver.unlocked!
      # Re raise error for response
      raise e
    end
  end
end

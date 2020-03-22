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
                            from: receiver.currency,
                            to: sender.currency,
                            amount: amount
                          )
                        else
                          amount
                        end

      # Block accounts
      sender.account.blocked!
      receiver.account.blocked!

      ActiveRecord::Base.transaction do
        sender_balance = sender.balance - transfer_amount
        receiver_balance = receiver.balance + transfer_amount
        sender.account.update!(balance: sender_balance)
        receiver.account.update!(balance: receiver_balance)
      end
      # Unblock account
      sender.account.active!
      receiver.account.active!
    rescue StandardError => e
      # Leave log
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      # Unblock for any error
      sender.account.active!
      receiver.account.active!
      # Re raise error for response
      raise e
    end
  end
end

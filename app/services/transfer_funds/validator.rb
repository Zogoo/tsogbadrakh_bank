# frozen_string_literal: true

module TransferFunds
  module Validator
    include Bank::Error

    def validate!(transaction)
      transaction.save! unless transaction.valid?

      sender = transaction.account
      receiver = transaction.receiver

      validate_account!(sender)
      validate_account!(receiver)
      validate_sender_account!(transaction)
    end

    def validate_account!(account)
      error = nil
      error ||= I18n.t('bank.errors.unable_process') unless account.unlocked?
      error ||= I18n.t('bank.errors.invalid_account_status') unless account.active?
      error ||= I18n.t('bank.errors.invalid_user_status') unless account.user.active?
      raise InvalidTransferRequest, error if error.present?
    end

    def validate_sender_account!(transaction)
      account = transaction.account
      error = nil
      error ||= I18n.t('bank.errors.cannot_transfer_from_savings') if account.savings?
      error ||= balance_enough?(transaction)

      raise InvalidTransferRequest, error if error.present?
    end

    def balance_enough?(transaction)
      amount = transaction.amount
      sender = transaction.account
      receiver = transaction.receiver
      balance = sender.balance

      return I18n.t('bank.errors.balance_not_enough') unless balance.positive?

      required_balance = if sender.currency != receiver.currency
                           ExchangeRateCalculator.calculate(
                             from: receiver.currency,
                             to: sender.currency,
                             amount: amount
                           )
                         else
                           amount
                         end
      return I18n.t('bank.errors.balance_not_enough') if balance < required_balance
    end
  end
end

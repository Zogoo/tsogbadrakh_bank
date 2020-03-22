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
      validat_relation!(sender, receiver)
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

    def validat_relation!(sender, receiver)
      if sender.id == receiver.id
        raise InvalidTransferRequest, I18n.t('bank.errors.same_account_not_allowed')
      end
    end

    def balance_enough?(transaction)
      amount = transaction.amount
      sender = transaction.account
      sender_balance = sender.balance

      unless sender_balance.positive? && (sender_balance - amount).positive?
        I18n.t('bank.errors.balance_not_enough')
      end
    end
  end
end

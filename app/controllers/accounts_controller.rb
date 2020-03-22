# frozen_string_literal: true

class AccountsController < ApplicationController
  include ErrorHandler
  include ResponseHandler

  def transfer
    sender = Account.find account_from
    receiver = Account.find account_to
    transaction = Transfer.create!(account: sender, receiver: receiver, amount: transfer_amount)
    TransferFunds.process(transaction)
    respond_with_json(message: t('bank.messages.successfully_transferred'))
  end

  def last
    last_transfers = Transfer.order(created_at: :desc).limit(limit_number)
    respond_with_json(last_transfers)
  end

  def single
    transfer = Transfer.find_by!(account_id: account_id).order(created_at: :desc)
    respond_with_json(transfer)
  end

  private

  def account_id
    params.require(:id)
  end

  def account_from
    params.require(:account_from)
  end

  def account_to
    params.require(:account_to)
  end

  def transfer_amount
    params.require(:transfer_amount)
  end

  def limit_number
    params.require(:limit_number)
  end
end

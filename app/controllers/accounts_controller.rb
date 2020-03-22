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

  def all
    last_10_tranfer = Transfer.order(created_at: :desc).limit(10)
    respond_with_json(last_10_tranfer)
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
end

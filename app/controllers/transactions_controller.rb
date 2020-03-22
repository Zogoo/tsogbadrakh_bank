# frozen_string_literal: true

class TransactionsController < ApplicationController
  include ErrorHandler
  include ResponseHandler

  def last
    last_transfers = Transfer.order(created_at: :desc).limit(limit_number || 10)
    respond_with_json(last_transfers)
  end

  def single
    transfers = Transfer.where(account_id: account_id, status: :completed)
                        .or(Transfer.where(reciever_id: account_id))
                        .order(created_at: :desc)
    respond_with_json(transfers)
  end

  def transfer
    sender = Account.find account_from
    reciever = Account.find account_to
    transaction = Transfer.create!(account: sender, reciever: reciever, amount: transfer_amount)
    TransferFunds.process(transaction)
    respond_with_json(message: t('bank.messages.successfully_transferred'))
  end

  private

  def limit_number
    params.dig(:limit_number)
  end

  def account_id
    params.require(:account_id)
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

# frozen_string_literal: true

class AccountsController < ApplicationController
  include ResponseHandler
  include ErrorHandler

  def single
    transfer = Account.find(account_id)
    respond_with_json(transfer)
  end

  private

  def account_id
    params.require(:account_id)
  end
end

# frozen_string_literal: true

class AccountsController < ApplicationController
  include ErrorHandler

  def transfer
    TransferHandler.transfer(account_from, account_to)
  end

  def all
  end

  def single
  end

  private

  def account_from
    params.require(:account_from)
  end

  def account_to
    params.require(:account_to)
  end
end

# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :branch
  has_many :accounts
  has_many :transactions
  has_one :profile

  enum status: %i[created active suspended blocked deleted]
  enum is_confirmed: { registered: false, confirmed: true }
end

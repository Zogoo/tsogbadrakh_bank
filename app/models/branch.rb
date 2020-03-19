# frozen_string_literal: true

class Branch < ApplicationRecord
  has_many :users

  enum kind: %i[bank virtual atm pos vendor]

  validates :serial_num, uniqueness: true
  validates :kind, inclusion: kinds.keys, presence: true
end

# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user

  enum is_confirmed: { registered: false, confirmed: true }

  validates :first_name, presence: true, length: { maximum: 150 }
  validates :last_name, presence: true, length: { maximum: 150 }
  validates :postal_code, presence: true
  validates :city, presence: true, length: { maximum: 150 }
  validates :address, presence: true
  validates :email, format: { with: /\A[^@\s]+@(?:[-a-zA-Z0-9]+\.)+[a-z]{2,}\z/ }, allow_blank: true
end

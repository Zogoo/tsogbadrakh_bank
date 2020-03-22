# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :receiver, foreign_key: :receiver_id, class_name: :Account

  enum status: %i[created processing completed failed]
end

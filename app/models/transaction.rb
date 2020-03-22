# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :reciever, foreign_key: :reciever_id, class_name: :Account

  enum status: %i[created processing completed failed]
end

# frozen_string_literal: true

module TransferFunds
  class << self
    include TransferFunds::Validator
    include TransferFunds::Processor

    def process(transaction)
      validate!(transaction)
      process!(transaction)
    end
  end
end

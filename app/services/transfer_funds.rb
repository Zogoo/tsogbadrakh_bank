# frozen_string_literal: true

module TansferFunds
  class << self
    include TansferFunds::Validator
    include TansferFunds::Handler

    def process(transaction)
      validate!(transaction)
      process!(transaction)
    end
  end
end

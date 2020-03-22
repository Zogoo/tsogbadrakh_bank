# frozen_string_literal: true

module Bank
  module Error
    class InvalidTransferRequest < StandardError; end
    class InvalidExchangeRate < StandardError; end
    class FailedInternalProcess < StandardError; end
  end
end

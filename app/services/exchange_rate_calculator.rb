# frozen_string_literal: true

class ExchangeRateCalculator
  def self.calculate(currency_from, currency_to, amount)
    rate = ExchangeRate.where(from: currency_from).where(to: currency_to).order(added_at: :desc).first

    unless rate.present?
      raise Bank::Error::ExchangeRateMissing, "Missing exchange rate from #{currency_from} to #{currency_to}"
    end

    amount * rate.rate
  end
end

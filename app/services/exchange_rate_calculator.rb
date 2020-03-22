# frozen_string_literal: true

class ExchangeRateCalculator
  def self.calculate(from: nil, to: nil, amount: nil)
    rate = ExchangeRate.rate_inclusion(from, to).first

    unless rate.present?
      raise Bank::Error::InvalidExchangeRate, I18n.t('bank.errors.missing_rate', from: from, to: to)
    end

    converted_amout = if from == rate.currency_from
                        amount * rate.rate
                      else
                        ((amount.to_f / rate.rate) * 100).to_i
                      end

    # Will not process less than 0.01 amount of money after converted with exchange rate
    unless converted_amout >= 1
      raise Bank::Error::InvalidExchangeRate, I18n.t('bank.errors.too_low_amount', lowest_amount: rate.rate.to_f / 100_00)
    end

    converted_amout
  end
end

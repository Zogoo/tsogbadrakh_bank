# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExchangeRateCalculator do
  let!(:usd_jpy) { create(:exchange_rate, :usd_jpy, rate: 110_00) }

  describe 'calculate' do
    context 'when convert one usd to jpy' do
      subject { described_class.calculate(from: 'usd', to: 'jpy', amount: 1_00) }
      it 'will return integer value' do
        expect(subject).to be_kind_of(Integer)
      end

      it 'will return rate' do
        expect(subject).to eq(usd_jpy.rate)
      end
    end

    context 'when convert 110 jpy to usd' do
      subject { described_class.calculate(from: 'jpy', to: 'usd', amount: 110_00) }
      it 'will return integer value' do
        expect(subject).to be_kind_of(Integer)
      end

      it 'will return 1/rate' do
        expect(subject).to eq(1_00)
      end
    end

    context 'when convert amount which will calculated as float amount' do
      subject { described_class.calculate(from: 'jpy', to: 'usd', amount: 55_00) }
      it 'will return integer value' do
        expect(subject).to be_kind_of(Integer)
      end

      it 'will round with last 2 digits' do
        expect(subject).to eq(50)
      end
    end

    context 'when convert amount which will calculated as float amount' do
      subject { described_class.calculate(from: 'jpy', to: 'usd', amount: 55_00) }
      it 'will return integer value' do
        expect(subject).to be_kind_of(Integer)
      end

      it 'will round with last 2 digits' do
        expect(subject).to eq(50)
      end
    end

    context 'when exchange non supported currency' do
      subject { described_class.calculate(from: 'mnt', to: 'usd', amount: 100_00) }
      it 'will raise error with specific message' do
        expect { subject }.to raise_error Bank::Error::InvalidExchangeRate,
                                          I18n.t('bank.errors.missing_rate', from: 'mnt', to: 'usd')
      end
    end

    context 'when exchange low amount of money' do
      subject { described_class.calculate(from: 'jpy', to: 'usd', amount: 10) }
      it 'will raise error with specific message' do
        expect { subject }.to raise_error Bank::Error::InvalidExchangeRate,
                                          I18n.t('bank.errors.too_low_amount', lowest_amount: usd_jpy.rate.to_f / 100_00)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExchangeRateCalculator do
  let!(:usd_jpy) { create(:exchange_rate, :usd_jpy, rate: 110_00) }

  describe 'calculate' do
    context 'when convert one usd to jpy' do
      it 'will return float value' do
        expect(described_class.calculate(from: 'usd', to: 'jpy', amount: 1_00)).to be_kind_of(Float)
      end

      it 'will return rate' do
        expect(described_class.calculate(from: 'usd', to: 'jpy', amount: 1_00)).to eq(usd_jpy.rate)
      end
    end

    context 'when convert 110 jpy to usd' do
      it 'will return 1/rate' do
        expect(described_class.calculate(from: 'jpy', to: 'usd', amount: 110_00)).to be_kind_of(Float)
      end

      it 'will return 1/rate' do
        expect(described_class.calculate(from: 'jpy', to: 'usd', amount: 110_00)).to eq(1.0)
      end
    end
  end
end

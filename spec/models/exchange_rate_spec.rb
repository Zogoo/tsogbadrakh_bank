# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  describe 'correct data' do
    context 'when add new exchange rate' do
      subject do
        ExchangeRate.create(
          from: 'euro',
          to: 'yen',
          rate: '118.96',
          added_at: Time.now
        )
      end

      it 'will create record on ExchangeRate' do
        expect { subject }.to change(ExchangeRate, :count).from(0).to(1)
      end
    end
  end
end

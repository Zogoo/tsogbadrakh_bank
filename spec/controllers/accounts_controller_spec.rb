# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let!(:exchange_rate) { create(:exchange_rate, :usd_jpy, rate: 118_97, added_at: Time.now) }
  let!(:branch) { create(:branch) }
  let!(:user_tom) { create(:user, branch: branch) }
  let!(:tom_usd_acc) { create(:account, :checking, user: user_tom, currency: 'usd', balance: 1_000_00) }
  let!(:tom_saving_acc) { create(:account, :savings, user: user_tom, currency: 'usd', balance: 1_000_00, interest_rate: 24, interest_period: 730) }
  let!(:user_hanzo) { create(:user, branch: branch) }
  let!(:hanzo_jpy_acc) { create(:account, :checking, user: user_hanzo, currency: 'jpy', balance: 100_00) }
  let!(:hanzo_savings_acc) do
    create(:account, :savings,
           user: user_hanzo,
           currency: 'jpy',
           balance: 1_000_00,
           interest_rate: 12,
           interest_period: 3650)
  end

  describe '#transfer' do
    context 'when transfer between valid resources' do
      subject do
        post :transfer, params: {
          account_from: tom_usd_acc.id,
          account_to: hanzo_jpy_acc.id,
          transfer_amount: 1_00
        }
      end

      it 'will get successful response and message' do
        subject
        expect(response).to be_successful
        expect(JSON.parse(response.body)['message']).to eq(I18n.t('bank.messages.successfully_transferred'))
      end

      it 'receiver user balance will be increased by transfered amount' do
        expect { subject }.to change(hanzo_jpy_acc, :balance).from(100_00).to(100_00 + exchange_rate.rate)
      end

      it 'sender balance will be decreased by transaction amount' do
        expect { subject }.to change(tom_usd_acc, :balance).from(1_000_00).to(1_000_00 - 1_00)
      end
    end
  end
end

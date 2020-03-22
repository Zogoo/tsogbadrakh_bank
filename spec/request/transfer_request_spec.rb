# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tranfser funds', type: :request do
  let!(:exchange_rate) { create(:exchange_rate, :usd_jpy, rate: 118_97, added_at: Time.now) }
  let!(:branch) { create(:branch) }
  let!(:user_tom) { create(:user, branch: branch) }
  let!(:tom_usd_acc) { create(:account, :checking, user: user_tom, currency: 'usd', balance: 1_000_00) }
  let!(:user_hanzo) { create(:user, branch: branch) }
  let!(:hanzo_jpy_acc) { create(:account, :checking, user: user_hanzo, currency: 'jpy', balance: 100_00) }

  describe 'POST transfer' do
    context 'with valid data' do
      it 'will return 200' do
        post transfer_transactions_url, params: {
          account_from: tom_usd_acc.id,
          account_to: hanzo_jpy_acc.id,
          transfer_amount: 1_00
        }
        expect(response).to be_successful
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransferFunds do
  let!(:exchange_rate) { create(:exchange_rate, :usd_jpy, rate: 110_97, added_at: Time.now) }
  let!(:branch) { create(:branch) }
  let!(:user_tom) { create(:user, branch: branch) }
  let!(:tom_usd_acc) { create(:account, :checking, user: user_tom, currency: 'usd', balance: 1_000_00) }
  let!(:tom_saving_acc) { create(:account, :savings, user: user_tom, currency: 'usd', balance: 1_000_00, interest_rate: 24, interest_period: 730) }
  let!(:user_bob) { create(:user, branch: branch) }
  let!(:bob_jpy_acc) { create(:account, :checking, user: user_bob, currency: 'jpy', balance: 100_32) }
  let!(:bob_saving_acc) { create(:account, :savings, user: user_bob, currency: 'jpy', balance: 1_000_00, interest_rate: 12, interest_period: 3650) }

  describe '#validate!' do
    context 'when validate valid transaction data' do
      let!(:transaction) { create(:transaction, account: tom_usd_acc, receiver: bob_jpy_acc, amount: 200_00) }

      it 'will not raise any error' do
        expect { described_class.validate!(transaction) }.not_to raise_error
      end
    end
  end

  describe '#process' do
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Branch, type: :model do
  describe 'association' do
    let!(:atm) { create(:branch, kind: :virtual) }

    context 'when user do transaction from atm' do
      let!(:user) { create(:user, branch: atm) }
      let!(:account_from) { create(:account, user: user) }
      let!(:account_to) { create(:account, user: user) }
      let!(:transaction) { create(:transaction, account: account_from, receiver: account_to) }
      it 'user will associate to branch' do
        expect(atm.users.count.positive?).to be_truthy
      end

      it 'accounts blongs to user' do
        expect(user.accounts.count.positive?).to be_truthy
      end

      it 'user will have transactions' do
        expect(user.transactions.count.positive?).to be_truthy
      end

      it 'transactions will associate to accounts' do
        expect(account_from.transactions.count.positive?).to be_truthy
      end
    end
  end
end

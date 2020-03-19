# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Branch, type: :model do
  describe 'association' do
    let!(:atm) { create(:branch, kind: :virtual) }

    context 'when atm user do one transaction' do
      let!(:user) { create(:user, branch: atm) }
      let!(:account_from) { create(:account, user: user) }
      let!(:account_to) { create(:account, user: user) }
      let(:transaction) { create(:transaction, account: account_from, receiver: account_to) }
      it 'user will associated to branch' do
        expect(atm.users.count.positive?).to be_truthy
      end
    end
  end
end

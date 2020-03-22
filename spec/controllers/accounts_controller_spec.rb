# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let!(:branch) { create(:branch) }
  let!(:user_tom) { create(:user, branch: branch) }
  let!(:tom_usd_acc) { create(:account, :checking, user: user_tom, currency: 'usd', balance: 1_000_00) }
  let!(:tom_saving_acc) { create(:account, :savings, user: user_tom, currency: 'usd', balance: 1_000_00, interest_rate: 24, interest_period: 730) }

  describe '#single' do
    context "when retrieve single account's transaction" do
      subject do
        get :single, params: {
          account_id: tom_usd_acc.id
        }
      end

      it 'will return all transactions with completed status' do
        subject
        expect(response).to be_successful
        expect(response.parsed_body).to be_kind_of(Object)
        expect(response.parsed_body['balance']).to eq(1_000_00)
      end
    end
  end
end

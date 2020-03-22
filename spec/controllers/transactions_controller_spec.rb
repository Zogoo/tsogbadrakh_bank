# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
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
    subject do
      post :transfer, params: {
        account_from: tom_usd_acc.id,
        account_to: hanzo_jpy_acc.id,
        transfer_amount: 1_00
      }
    end

    context 'when transfer between valid data for tranfer fund' do
      it 'will respond successful response and message' do
        subject
        expect(response).to be_successful
        expect(JSON.parse(response.body)['message']).to eq(I18n.t('bank.messages.successfully_transferred'))
      end

      it 'will tranfser money from hanzo to tom' do
        subject
        expect(hanzo_jpy_acc.reload.balance).to eq(100_00 + exchange_rate.rate)
        expect(tom_usd_acc.reload.balance).to eq(1_000_00 - 1_00)
      end
    end

    context 'when transfer between other way around (jpy to us)' do
      let!(:hanzo_jpy_acc) { create(:account, :checking, user: user_hanzo, currency: 'jpy', balance: 100_000_00) }

      subject do
        post :transfer, params: {
          account_from: hanzo_jpy_acc.id,
          account_to: tom_usd_acc.id,
          transfer_amount: 118_97
        }
      end

      it 'will respond successful response and message' do
        subject
        expect(response).to be_successful
        expect(JSON.parse(response.body)['message']).to eq(I18n.t('bank.messages.successfully_transferred'))
      end

      it 'will tranfser money from hanzo to tom' do
        subject
        expect(hanzo_jpy_acc.reload.balance).to eq(100_000_00 - 118_97)
        expect(tom_usd_acc.reload.balance).to eq(1_000_00 + 1_00)
      end
    end

    context 'when transfer with less than 0.01 usd' do
      subject do
        post :transfer, params: {
          account_from: hanzo_jpy_acc.id,
          account_to: tom_usd_acc.id,
          transfer_amount: 1
        }
      end

      it 'will respond with 400 error and message' do
        subject
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)['error']).to match(/^Please specify greater than .*$/)
      end

      it 'will not change account balances' do
        subject
        expect(hanzo_jpy_acc.reload.balance).to eq(100_00)
        expect(tom_usd_acc.reload.balance).to eq(1_000_00)
      end
    end

    context 'when transfer with negative amount' do
      subject do
        post :transfer, params: {
          account_from: hanzo_jpy_acc.id,
          account_to: tom_usd_acc.id,
          transfer_amount: -118_97
        }
      end

      it 'will respond with 400 error and message' do
        subject
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)['error']).to eq('Transfer amount  must be greater than 0.')
      end
    end

    context 'when transfer request hast non existing account id' do
      subject do
        post :transfer, params: {
          account_from: 99,
          account_to: hanzo_jpy_acc.id,
          transfer_amount: 1_00
        }
      end

      it 'will respond with 400 error code and error message' do
        subject
        expect(response).to have_http_status(400)
        expect(response.parsed_body['error']).to match(/^Couldn't find Account with .*$/)
      end
    end

    context 'when user locked' do
      before do
        user_tom.blocked!
        user_hanzo.blocked!
      end

      it 'will respond with 400 error code and error message' do
        subject
        expect(response).to have_http_status(400)
        expect(response.parsed_body['error']).to eq(I18n.t('bank.errors.invalid_user_status'))
      end
    end

    context 'when account is blocked' do
      before do
        tom_usd_acc.blocked!
        user_hanzo.blocked!
      end

      it 'will respond with 400 error code and error message' do
        subject
        expect(response).to have_http_status(400)
        expect(response.parsed_body['error']).to eq(I18n.t('bank.errors.invalid_account_status'))
      end
    end

    context 'when exchange rate not exist' do
      let!(:exchange_rate) { create(:exchange_rate, :eur_jpy, rate: 119_44, added_at: Time.now) }

      it 'will respond with 400 error code and error message' do
        subject
        expect(response).to have_http_status(400)
        expect(response.parsed_body['error']).to eq(I18n.t('bank.errors.missing_rate', from: 'usd', to: 'jpy'))
      end
    end

    context 'when error occur during tranfser' do
      before do
        allow_any_instance_of(Transaction).to receive(:update!).and_raise Bank::Error::FailedInternalProcess.new('error')
      end

      it 'will respond with 500 error code and general error message' do
        subject
        expect(response).to have_http_status(500)
        expect(response.parsed_body['error']).to eq(I18n.t('bank.errors.general'))
      end
    end

    context 'when internal erro happen' do
      before do
        allow_any_instance_of(Transaction).to receive(:update!).and_raise StandardError.new('error')
      end

      it 'will respond with 500 error code and general error message' do
        subject
        expect(response).to have_http_status(500)
        expect(response.parsed_body['error']).to eq(I18n.t('bank.errors.general'))
      end
    end
  end

  describe '#last' do
    context 'when retreive last 10 transaction' do
      subject do
        get :last, params: {
          limit_number: 10
        }
      end
      before do
        10.times do
          post :transfer, params: {
            account_from: tom_usd_acc.id,
            account_to: hanzo_jpy_acc.id,
            transfer_amount: 1_00
          }
        end
      end

      it 'will respond with successful response and array of data' do
        subject
        expect(response).to be_successful
        expect(response.parsed_body).to be_kind_of(Array)
      end

      it 'will return array with last 10 transaction' do
        subject
        expect(response.parsed_body.size).to eq(10)
        expect(response.parsed_body.first).to be_kind_of(Object)
        expect(response.parsed_body.first['amount']).to eq(100)
        expect(response.parsed_body.second['amount']).to eq(100)
        expect(response.parsed_body.third['amount']).to eq(100)
        expect(response.parsed_body.last['amount']).to eq(100)
      end
    end
  end
end

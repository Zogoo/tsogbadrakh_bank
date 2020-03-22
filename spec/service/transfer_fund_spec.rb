# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransferFunds do
  let!(:exchange_rate) { create(:exchange_rate, :usd_jpy, rate: 110_97, added_at: Time.now) }
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

  describe '#validate!' do
    subject { described_class.validate!(transaction) }

    context 'when validate valid transaction data' do
      let!(:transaction) { create(:transfer, account: tom_usd_acc, receiver: hanzo_jpy_acc, amount: 200_00) }

      it 'will not raise any error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when validate transaction with negative amount' do
      let(:transaction) { create(:transfer, account: tom_usd_acc, receiver: hanzo_jpy_acc, amount: -10) }

      it 'will raise error' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context 'when validate transaction with savings account' do
      let!(:transaction) { create(:transfer, account: tom_saving_acc, receiver: hanzo_jpy_acc, amount: 100_00) }

      it 'will raise error' do
        expect { subject }.to raise_error Bank::Error::InvalidTransferRequest,
                                          I18n.t('bank.errors.cannot_transfer_from_savings')
      end
    end

    context 'when account is not active' do
      let!(:transaction) { create(:transfer, account: tom_usd_acc, receiver: hanzo_jpy_acc, amount: 100_00) }

      before do
        tom_usd_acc.suspended!
      end

      it 'will raise error' do
        expect { subject }.to raise_error Bank::Error::InvalidTransferRequest,
                                          I18n.t('bank.errors.invalid_account_status')
      end
    end

    context 'when account owner has not active status' do
      let!(:transaction) { create(:transfer, account: tom_usd_acc, receiver: hanzo_jpy_acc, amount: 100_00) }

      before do
        user_tom.blocked!
      end

      it 'will raise error' do
        expect { subject }.to raise_error Bank::Error::InvalidTransferRequest,
                                          I18n.t('bank.errors.invalid_user_status')
      end
    end
  end

  describe '#process!' do
    subject { described_class.process!(transaction) }

    context 'when process valid transaction data' do
      let!(:transaction) { create(:transfer, account: tom_usd_acc, receiver: hanzo_jpy_acc, amount: 1_00) }

      it 'will not raise any error' do
        expect { subject }.not_to raise_error
      end

      it 'receiver user balance will be increased by transfered amount' do
        expect { subject }.to change(hanzo_jpy_acc, :balance).from(100_00).to(100_00 + 110_97)
      end

      it 'sender balance will be decreased by transaction amount' do
        expect { subject }.to change(tom_usd_acc, :balance).from(1_000_00).to(1_000_00 - transaction.amount)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  let!(:account) { create(:account) }

  describe 'association' do
    context 'when user create an account' do
      before do
        account.user.save!
      end

      it 'that belongs to user' do
        expect(account.user.present?).to be_truthy
      end
    end

    context 'when user transfer money' do
      let!(:transfer) { create(:transaction, account: account) }

      it 'that belongs to user' do
        expect(account.transactions.count).to eq(1)
      end
    end
  end

  describe 'validation' do
    context 'when update with invalid kind' do
      subject do
        account.update!(kind: :invalid_kind)
      end

      it 'will raise error' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid,
                                          I18n.t('activerecord.attributes.account.kind') \
                                          + ' ' \
                                          + I18n.t('activerecord.errors.models.account.attributes.kind.inclusion')\
                                          + ", Account type can't be blank"
      end
    end

    context 'when update with invalid status' do
      subject do
        account.update!(status: :invalid_status)
      end

      it 'will raise error' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid,
                                          I18n.t('activerecord.attributes.account.status') \
                                          + ' ' \
                                          + I18n.t('activerecord.errors.models.account.attributes.status.inclusion') \
                                          + ", Status can't be blank"
      end
    end

    context 'when update with invalid iterest rate' do
      subject do
        account.update!(interest_rate: 'test')
      end

      it 'will raise error' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid,
                                          I18n.t('activerecord.attributes.account.interest_rate') \
                                          + ' ' \
                                          + I18n.t('activerecord.errors.models.account.attributes.interest_rate.not_a_number')
      end
    end

    context 'when update with negative iterest rate' do
      subject do
        account.update!(interest_rate: -0.33)
      end

      it 'will raise error' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid,
                                          I18n.t('activerecord.attributes.account.interest_rate') \
                                          + ' ' \
                                          + I18n.t('activerecord.errors.models.account.attributes.interest_rate.greater_than')
      end
    end

    context 'when update with over 100% iterest rate' do
      subject do
        account.update!(interest_rate: 122)
      end

      it 'will raise error' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid,
                                          I18n.t('activerecord.attributes.account.interest_rate') \
                                          + ' ' \
                                          + I18n.t('activerecord.errors.models.account.attributes.interest_rate.less_than')
      end
    end

    context 'when update with invalid value' do
      subject do
        account.update!(interest_period: 'One hunder day')
      end

      it 'will raise error' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid,
                                          I18n.t('activerecord.attributes.account.interest_period') \
                                          + ' ' \
                                          + I18n.t('activerecord.errors.models.account.attributes.interest_period.not_a_number')
      end
    end

    context 'when update with negative interest period' do
      subject do
        account.update!(interest_period: -365)
      end

      it 'will raise error' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid,
                                          I18n.t('activerecord.attributes.account.interest_period') \
                                          + ' ' \
                                          + I18n.t('activerecord.errors.models.account.attributes.interest_period.greater_than')
      end
    end
  end

  describe 'correct values' do
    let(:correct_values) do
      {
        kind: :savings,
        status: :active,
        currency: 'usd',
        balance: 10_000,
        interest_rate: 33,
        interest_period: 3650
      }
    end

    subject do
      account.update!(correct_values)
    end

    context 'when update with correct values' do
      it 'will not raise any error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when update with string numbers' do
      let(:str_balance) { '9999' }
      let(:str_interest_rate) { '22' }
      let(:str_interest_period) { '365' }
      let(:correct_values) do
        {
          kind: :savings,
          status: :active,
          currency: 'usd',
          balance: str_balance,
          interest_rate: str_interest_rate,
          interest_period: str_interest_period
        }
      end

      it 'will not raise any error' do
        expect { subject }.not_to raise_error
      end

      it 'will store string values as integer' do
        subject
        expect(account.balance).to eq(str_balance.to_i)
        expect(account.interest_rate).to eq(str_interest_rate.to_i)
        expect(account.interest_period).to eq(str_interest_period.to_i)
      end
    end
  end

  describe 'data format' do
    context 'when convert balance as float' do
      before do
        account.update!(balance: 1_000_000)
      end

      it 'will return float value' do
        expect(account.balance_as_float).to be_kind_of(Float)
      end

      it 'will return hunder times less value' do
        expect(account.balance_as_float).to eq(10_000.0)
      end
    end

    context 'when convert interest rate as float' do
      before do
        account.update!(interest_rate: 33)
      end

      it 'will return float value' do
        expect(account.interest_rate_as_float).to be_kind_of(Float)
      end

      it 'will return hunder times less value' do
        expect(account.interest_rate_as_float).to eq(0.33)
      end
    end

    context 'when convert interest period as float' do
      before do
        account.update!(interest_period: 365)
      end

      it 'will return float value' do
        expect(account.interest_period_by_year).to be_kind_of(Float)
      end

      it 'will return value as year' do
        expect(account.interest_period_by_year).to eq(1.0)
      end
    end
  end

  describe 'lock status' do
    let!(:locked_account) { create(:account, lock_state: :locked) }

    context 'when try to increase balance for locked account' do
      it 'will not allow any update' do
        expect { locked_account.update!(balance: 9_999_00) }.to raise_error Bank::Error::FailedInternalProcess,
                                                                            'This account is locked!. Please unlock first'
      end
    end

    context 'when try to increase balance with unlock state' do
      it 'will not raise any error' do
        expect { locked_account.update!(balance: 9_999_00, lock_state: :unlocked) }.not_to raise_error
      end
    end
  end
end

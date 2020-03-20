# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:transaction) { create(:transaction) }
  describe 'association' do
    context 'when user do some transaction' do
      before do
        transaction.account.save!
        transaction.receiver.save!
      end

      it "will associated to sender's accounts" do
        expect(transaction.account).to be_kind_of(Account)
      end

      it "will associated to receiver's account" do
        expect(transaction.receiver).to be_kind_of(Account)
      end
    end
  end

  describe 'transaction type' do
    context 'when convert transaction' do
      before do
        transaction.update!(type: Transfer.to_s)
      end

      it 'model will be Transfer' do
        expect(transaction.id).to eq(Transfer.first.id)
      end
    end
  end

  describe 'validation' do
    let!(:transfer) { create(:transaction, :transfer) }
    context 'when create transfer with negative amount' do
      subject do
        Transfer.first.update!(amount: -10_000)
      end

      it 'will raise error' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid,
                                          I18n.t('activerecord.attributes.transfer.amount') \
                                          + ' ' \
                                          + I18n.t('activerecord.errors.models.transfer.attributes.amount.greater_than')
      end
    end
  end
end

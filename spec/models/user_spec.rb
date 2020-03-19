# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:branch) { create(:branch) }
  let!(:user) { create(:user, branch: branch) }

  describe 'association' do
    context 'when user create profile' do
      before do
        user.profile.save!
      end

      it 'user will have a profile' do
        expect(user.profile.present?).to be_truthy
      end
    end
  end

  describe 'validation' do
    context 'when try to create user with duplicated uuid' do
      subject do
        User.create!(uuid: user.uuid, branch: branch)
      end

      it 'will raise error' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid,
                                          I18n.t('activerecord.attributes.user.uuid') \
                                          + ' ' \
                                          + I18n.t('activerecord.errors.models.user.attributes.uuid.taken')
      end
    end
  end
end

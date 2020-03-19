# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  let!(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }

  describe 'association' do
    context 'when user create profile' do
      it 'profile belongs to user' do
        expect(profile.user.present?).to be_truthy
      end
    end
  end

  describe 'validation' do
    context 'when first name exceeded 150 character' do
      let!(:very_long_name) { Faker::Name.initials(number: 200) }

      subject do
        profile.update!(first_name: very_long_name)
      end

      it 'will raise error' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid,
                                          I18n.t('activerecord.attributes.profile.first_name') \
                                          + ' ' \
                                          + I18n.t('activerecord.errors.models.profile.attributes.first_name.too_long')
      end
    end
  end
end

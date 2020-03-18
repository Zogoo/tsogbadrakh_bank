# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionView::Helpers::TranslationHelper

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end

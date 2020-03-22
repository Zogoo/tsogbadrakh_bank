# frozen_string_literal: true

# Common errors will be handed by common error
module ErrorHandler
  extend ActiveSupport::Concern

  included do
    # Note: Order is very important in here
    rescue_from StandardError, with: :report_and_respond_general_error
    rescue_from ActiveRecord::RecordNotFound, with: :respond_resource_not_found
    rescue_from Bank::Error::FailedInternalProcess, with: :respond_general_error
    rescue_from ActiveRecord::RecordInvalid, with: :respond_expected_error
    rescue_from Bank::Error::InvalidExchangeRate, with: :respond_expected_error
    rescue_from Bank::Error::InvalidTransferRequest, with: :respond_expected_error
    rescue_from ActionController::ParameterMissing, with: :respond_paramer_missing

    private

    def respond_expected_error(error)
      render json: { error: error.message }, status: 400
    end

    # IMPROVE: Change to more user friendly error message
    def respond_resource_not_found(error)
      render json: { error: error.message }, status: 400
    end

    # IMPROVE: Change to more user friendly error message
    def respond_paramer_missing(error)
      render json: { error: error.message }, status: 400
    end

    def respond_general_error
      render json: { error: t('bank.errors.general') }, status: 500
    end

    def report_and_respond_general_error(error)
      logger.error '***** Unexpected error happening ******'
      logger.error error.message
      logger.error error.backtrace.join("\n")
      respond_general_error
    end
  end
end

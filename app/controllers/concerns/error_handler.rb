# frozen_string_literal: true

# Common errors will be handed by common error
module ErrorHandler
  extend ActiveSupport::Concern
  included do
    rescue_from Bank::Error::InvalidTransferRequest, with: :respond_for_invalid_transfer
    rescue_from ActionController::ParameterMissing, with: :respond_paramer_missing
    rescue_from ActiveRecord::RecordNotFound, with: :respond_resource_not_found
    rescue_from FailedInternalProcess, with: :respond_general_error
    rescue_from StandardError, with: :respond_general_error

    private

    def respond_for_invalid_csv(error)
      render json: { error: error.message }, status: 400
    end

    # IMPROVE: Change to more user friendly error message
    def respond_paramer_missing(error)
      render json: { error: error.message }, status: 400
    end

    # IMPROVE: Change to more user friendly error message
    def respond_resource_not_found(error)
      render json: { error: error.message }, status: 400
    end

    def respond_general_error(error)
      logger.error '***** Unexpected error happening ******'
      logger.error error.message
      logger.error error.backtrace.join("\n")
      render json: { error: t('bank.errors.general') }, status: 500
    end
  end
end

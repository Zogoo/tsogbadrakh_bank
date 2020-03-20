# frozen_string_literal: true

# Common errors will be handed by common error
module ResponseHandler
  def respond_with_json(object, status = :ok)
    render json: object, status: status
  end
end

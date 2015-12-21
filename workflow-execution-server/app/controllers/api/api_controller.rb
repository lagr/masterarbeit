class Api::ApiController < ApplicationController
  before_action :set_default_response_format

  private

  def respond_with_ok
    render json: {}, status: :ok
  end
  def respond_with_error
    render json: {}, status: :error
  end

  def set_default_response_format
    request.format = :json
  end
end

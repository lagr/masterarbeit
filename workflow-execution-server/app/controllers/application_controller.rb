class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception

  def index
  end

  def status
    render json: {status: 'available'}
  end
end

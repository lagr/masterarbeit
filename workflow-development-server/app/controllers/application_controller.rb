class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
  end

  def workflow
    render json: {id: params[:id]}
  end
  #   render layout: layout_name
  # end

  # private

  # def layout_name
  #   if params[:layout] == 0
  #     false
  #   else
  #     'application'
  #   end
  # end
  
  end

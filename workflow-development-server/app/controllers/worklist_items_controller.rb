class WorklistItemsController < ApplicationController
  def index
    render json: WorklistItem.where(user: params[:user_id])
  end
  def show
    render json: WorklistItem.find(params[:id])
  end
end

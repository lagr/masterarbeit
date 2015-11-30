class WorklistsController < ApplicationController
  def show
    render json: Worklist.find(params[:id])
  end
end

class WorkflowVersionsController < ApplicationController

  def show
    render json: WorkflowVersion.find(params[:id])
  end
end

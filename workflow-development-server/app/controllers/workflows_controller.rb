class WorkflowsController < ApplicationController
  def index
    render json: Workflow.all
  end

  def show
    render json: Workflow.find(params[:id])
  end
end

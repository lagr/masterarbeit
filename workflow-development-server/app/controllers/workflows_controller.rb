class WorkflowsController < ApplicationController

  def show
    render json: Workflow.find(params[:id])
  end
end

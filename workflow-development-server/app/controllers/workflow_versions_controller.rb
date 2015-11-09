class WorkflowVersionsController < ApplicationController

  def show
    @workflow_version = WorkflowVersion.find(params[:id])
    if params[:for_designer]
      render json: @workflow_version, serializer: WorkflowVersionFullSerializer
    else
      render json: @workflow_version, serializer: WorkflowVersionSerializer
    end
  end
end

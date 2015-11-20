class WorkflowVersionsController < ApplicationController

  def show
    @workflow_version = WorkflowVersion.find(params[:id])
    if params[:for_designer]
      render json: @workflow_version, serializer: WorkflowVersionFullSerializer, include: [
        'process_definition', 'process_definition.process_elements', 'process_definition.control_flows', 'workflow.name'
      ]
    else
      render json: @workflow_version, serializer: WorkflowVersionSerializer
    end
  end
end

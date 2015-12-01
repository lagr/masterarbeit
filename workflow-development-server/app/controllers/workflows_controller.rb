class WorkflowsController < ApplicationController
  def index
    render json: Workflow.all
  end
  
  def show
    @workflow = Workflow.find(params[:id])
    if params[:for_designer]
      render json: @workflow, serializer: WorkflowFullSerializer, include: [
        'process_definition', 'process_definition.process_elements', 'process_definition.control_flows', 'workflow.name'
      ]
    else
      render json: @workflow, serializer: WorkflowSerializer
    end
  end

  def update
    @workflow = Workflow.find(params[:id])
    if @workflow.update_attributes(workflow_params)
      render json: @workflow
    else
      render json: { errors: @workflow.errors }, status: :unprocessable_entity
    end
  end

  def create
    if @workflow = Workflow.create
      render json: @workflow
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def destroy
    @workflow = Workflow.find(params[:id])
    if @workflow.destroy
      render json: @workflow, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  private

  def workflow_params
    params.require(:workflow).permit(:name, :user)
  end
end

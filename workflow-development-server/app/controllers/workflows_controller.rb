class WorkflowsController < ApplicationController
  def index
    render json: Workflow.all
  end

  def show
    render json: Workflow.find(params[:id])
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

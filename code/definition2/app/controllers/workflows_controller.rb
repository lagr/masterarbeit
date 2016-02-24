class WorkflowsController < ApplicationController
  before_action :set_workflow, only: [:show, :update, :destroy]

  def index
    @workflows = Workflow.all
    render json: @workflows
  end

  def show
    render json: @workflow, serializer: WorkflowFullSerializer, include: '**'
  end

  def create
    @workflow = Workflow.new(workflow_params)

    if @workflow.save
      render json: @workflow, status: :created, location: @workflow
    else
      render json: @workflow.errors, status: :unprocessable_entity
    end
  end

  def update
    @workflow = Workflow.find(params[:id])

    if @workflow.update(workflow_params)
      head :no_content
    else
      render json: @workflow.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @workflow.destroy
    head :no_content
  end

  private

    def set_workflow
      @workflow = Workflow.find(params[:id])
    end

    def workflow_params
      params.require(:workflow).permit(:name, :user_id)
    end
end

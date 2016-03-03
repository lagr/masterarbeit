class WorkflowsController < ApplicationController
  def index
    @workflows = mq_request 'workflow.index', 'workflow.indexed', {}
    render json: @workflows
  end

  def show
    @workflow = mq_request 'workflow.show', 'workflow.showed', id: params[:id]
    render json: @workflow
  end

  def create
    @workflow = mq_request 'workflow.create', 'workflow.created', workflow: workflow_params
    render json: @workflow, status: :created
  end

  def update
    @workflow = mq_request 'workflow.update', 'workflow.updated', workflow: workflow_params, id: params[:id]
    @workflow = mq_request 'workflow.export', 'workflow.exported', id: params[:id]
    render json: @workflow, status: :created
  end

  def destroy
    mq_request 'wfms.workflow.destroy', 'wfms.workflow.destroyed', id: params[:id]
    head :no_content
  end

  def export
    rq = new_response_queue("wfms.workflow.exported", 0)
    Hutch.publish "wfms.workflow.export", payload
    get_response(rq)
    head :no_content
  end

  def start_instance
    Hutch.publish "wfms.workflow.start", id: params[:id], input_data: { this: 'is a test' }
    head :no_content
  end

  private

  def workflow_params
    params.require(:workflow).permit(:name, :user_id)
  end
end

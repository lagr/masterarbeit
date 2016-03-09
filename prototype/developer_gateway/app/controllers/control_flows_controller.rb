class ControlFlowsController < ApplicationController
  def index
    @control_flows = mq_request 'control_flow.index', 'control_flow.indexed', {}
    render json: @control_flows
  end

  def show
    @control_flow = mq_request 'control_flow.show', 'control_flow.showed', id: params[:id]
    render json: @control_flow
  end

  def create
    @control_flow = mq_request 'control_flow.create', 'control_flow.created', control_flow: control_flow_params
    render json: @control_flow, status: :created
  end

  def update
    @control_flow = mq_request 'control_flow.update', 'control_flow.updated', control_flow: control_flow_params, id: params[:id]
    render json: @control_flow
  end

  def destroy
    mq_request 'wfms.control_flow.destroy', 'wfms.control_flow.destroyed', id: params[:id]
    head :no_content
  end

  private

  def control_flow_params
    params.require(:control_flow).permit(:successor_id, :predecessor_id, :process_definition_id)
  end
end

class ControlFlowsController < ApplicationController
  before_action :set_control_flow, only: [:show, :update, :destroy]

  def index
    @control_flows = ControlFlow.all
    render json: @control_flows
  end

  def show
    render json: @control_flow
  end

  def create
    @control_flow = ControlFlow.new(control_flow_params)

    if @control_flow.save
      render json: @control_flow, status: :created, location: @control_flow
    else
      render json: @control_flow.errors, status: :unprocessable_entity
    end
  end

  def update
    @control_flow = ControlFlow.find(params[:id])

    if @control_flow.update(control_flow_params)
      head :no_content
    else
      render json: @control_flow.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @control_flow.destroy
    head :no_content
  end

  private

    def set_control_flow
      @control_flow = ControlFlow.find(params[:id])
    end

    def control_flow_params
      params.require(:control_flow).permit(:process_definition_id, :successor_id, :predecessor_id)
    end
end

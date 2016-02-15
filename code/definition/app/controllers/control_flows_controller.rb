class ControlFlowsController < ApplicationController
  before_action :set_control_flow, only: [:show, :update, :destroy]

  # GET /control_flows
  # GET /control_flows.json
  def index
    @control_flows = ControlFlow.all

    render json: @control_flows
  end

  # GET /control_flows/1
  # GET /control_flows/1.json
  def show
    render json: @control_flow
  end

  # POST /control_flows
  # POST /control_flows.json
  def create
    @control_flow = ControlFlow.new(control_flow_params)

    if @control_flow.save
      render json: @control_flow, status: :created, location: @control_flow
    else
      render json: @control_flow.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /control_flows/1
  # PATCH/PUT /control_flows/1.json
  def update
    @control_flow = ControlFlow.find(params[:id])

    if @control_flow.update(control_flow_params)
      head :no_content
    else
      render json: @control_flow.errors, status: :unprocessable_entity
    end
  end

  # DELETE /control_flows/1
  # DELETE /control_flows/1.json
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

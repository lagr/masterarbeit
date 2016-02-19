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
    @control_flow.update_attributes(control_flow_params)

    if @control_flow.save
      head :no_content
    else
      render json: @control_flow.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @control_flow.destroy

    head :no_content
  end

  def export
    redirect_to @control_flow, notice: 'Exported'
  end

  def start_instance
    redirect_to @control_flow, notice: 'Started'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_control_flow
      @control_flow = ControlFlow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def control_flow_params
      params.require(:control_flow).permit(:successor_id, :predecessor_id, :process_definition_id)
    end
end

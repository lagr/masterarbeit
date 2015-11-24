class ControlFlowsController < ApplicationController
  def create
    if @control_flow = ControlFlow.create(control_flow_params)
      render json: @control_flow
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def destroy
    @control_flow = ControlFlow.find(params[:id])
    if @control_flow.destroy
      render json: @control_flow, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  private
  def control_flow_params
    params.require(:control_flow).permit(:successor_id, :successor_type, :predecessor_id, :predecessor_type, :process_definition_id)
  end
end

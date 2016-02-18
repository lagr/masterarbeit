class WorkflowsController < ApplicationController
  before_action :set_workflow, only: [:show, :update, :destroy]

  # GET /workflows
  # GET /workflows.json
  def index
    @workflows = Workflow.all

    render json: @workflows
  end

  # GET /workflows/1
  # GET /workflows/1.json
  def show
    render json: @workflow
  end

  # POST /workflows
  # POST /workflows.json
  def create
    @workflow = Workflow.new(workflow_params)

    if @workflow.save
      render json: @workflow, status: :created, location: @workflow
    else
      render json: @workflow.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /workflows/1
  # PATCH/PUT /workflows/1.json
  def update
    @workflow.update_attributes(workflow_params)

    if @workflow.save
      head :no_content
    else
      render json: @workflow.errors, status: :unprocessable_entity
    end
  end

  # DELETE /workflows/1
  # DELETE /workflows/1.json
  def destroy
    @workflow.destroy

    head :no_content
  end

  def export
    redirect_to @workflow, notice: 'Exported'
  end

  def start_instance
    redirect_to @workflow, notice: 'Started'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workflow
      @workflow = Workflow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workflow_params
      params.require(:workflow).permit(:name, :user_id)
    end
end

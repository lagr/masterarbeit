class ProcessDefinitionsController < ApplicationController
  before_action :set_process_definition, only: [:show, :update, :destroy]

  # GET /process_definitions
  # GET /process_definitions.json
  def index
    @process_definitions = ProcessDefinition.all

    render json: @process_definitions
  end

  # GET /process_definitions/1
  # GET /process_definitions/1.json
  def show
    render json: @process_definition
  end

  # POST /process_definitions
  # POST /process_definitions.json
  def create
    @process_definition = ProcessDefinition.new(process_definition_params)

    if @process_definition.save
      render json: @process_definition, status: :created, location: @process_definition
    else
      render json: @process_definition.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /process_definitions/1
  # PATCH/PUT /process_definitions/1.json
  def update
    @process_definition = ProcessDefinition.find(params[:id])

    if @process_definition.update(process_definition_params)
      head :no_content
    else
      render json: @process_definition.errors, status: :unprocessable_entity
    end
  end

  # DELETE /process_definitions/1
  # DELETE /process_definitions/1.json
  def destroy
    @process_definition.destroy

    head :no_content
  end

  private

    def set_process_definition
      @process_definition = ProcessDefinition.find(params[:id])
    end

    def process_definition_params
      params.require(:process_definition).permit(:workflow_id)
    end
end

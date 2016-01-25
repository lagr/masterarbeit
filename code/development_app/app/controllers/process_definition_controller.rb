class ProcessDefinitionController < ApplicationController
  before_action :set_process_definition, only: [:edit, :update]

  def edit
  end

  def update
    if true
      ImageManager.export_workflow(@process_definition.workflow)
    end
  end

  private

  def set_process_definition
    @process_definition = ProcessDefinition.find(params[:id])
  end

  def process_definition_params
    params.require(:process_definition).permit()
  end
end

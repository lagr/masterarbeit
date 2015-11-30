class ProcessElementsController < ApplicationController
  def create
    @process_definition = ProcessDefinition.find(process_element_creation_params[:process_definition_id])
    element_type = process_element_creation_params[:element_type]

    return unless @process_definition && element_type.in?(Workflow::PROCESS_ELEMENT_TYPES)

    @actual_element = element_type.constantize.new
    @process_element = @process_definition.process_elements.build element: @actual_element

    if @process_element.save
      render json: @process_element
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
    @process_element = ProcessElement.find(params[:id])
    if @process_element.destroy
      render json: {}, status: :ok
    else
      render json: {}, status: :error
    end
  end

  private

  def process_element_creation_params
    params.require(:process_element).permit(:element_type,:process_definition_id)
  end

  def process_element_update_params
    params.require(:process_element).permit(:name, :x, :y)
  end

  def allowed_process_element_type?(type)
    type.in? Workflow::PROCESS_ELEMENT_TYPES
  end
end

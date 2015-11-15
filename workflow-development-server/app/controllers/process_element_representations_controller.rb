class ProcessElementRepresentationsController < ApplicationController
  def update
    @process_element_representation = ProcessElementRepresentation.find(params[:id])
    if @process_element_representation.update_attributes(process_element_representation_params)
      render json: @process_element_representation
    else
      render json: { errors: @process_element_representation.errors }, status: :unprocessable_entity
    end
  end

  private

  def process_element_representation_params
    params.require(:process_element_representation).permit(:name, :x, :y)
  end
end

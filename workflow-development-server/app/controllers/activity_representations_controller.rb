class ActivityRepresentationsController < ApplicationController
  def update
    @activity_representation = ActivityRepresentation.find(params[:id])
    if @activity_representation.update_attributes(activity_representation_params)
      render json: @activity_representation
    else
      render json: { errors: @activity_representation.errors }, status: :unprocessable_entity
    end
  end

  private

  def activity_representation_params
    params.require(:activity_representation).permit(:name, :x, :y)
  end
end

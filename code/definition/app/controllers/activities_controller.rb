class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :update, :destroy]

  def index
    @activities = Activity.all
    render json: @activities
  end

  def show
    render json: @activity
  end

  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      render json: @activity, status: :created, location: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  def update
    @activity = Activity.find(params[:id])

    if @activity.update(activity_params)
      head :no_content
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @activity.destroy
    head :no_content
  end

  private

    def set_activity
      @activity = Activity.find(params[:id])
    end

    def activity_params
      params.require(:activity).permit(:name, :activity_type, :process_definition_id, :subworkflow_id, :input_schema, :output_schema, :activity_configuration, :representation, :participant_role_id)
    end
end

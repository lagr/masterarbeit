class ActivitiesController < ApplicationController
  def create
    @process_definition = ProcessDefinition.find(activity_creation_params[:process_definition_id])
    activity_type = activity_creation_params[:activity_type]

    return unless @process_definition && activity_type.in?(Activity::ACTIVITY_TYPES)

    @actual_activity = activity_type.constantize.new
    @activity = @process_definition.activities.build activity: @actual_activity

    if @activity.save
      render json: @activity
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
    @activity = Activity.find(params[:id])
    if @activity.destroy
      render json: {}, status: :ok
    else
      render json: {}, status: :error
    end
  end

  private

  def activity_creation_params
    params.require(:activity).permit(:activity_type,:process_definition_id)
  end

  def activity_update_params
    params.require(:activity).permit(:name, :x, :y)
  end

  def allowed_activity_type?(type)
    type.in? Activity::ACTIVITY_TYPES
  end
end

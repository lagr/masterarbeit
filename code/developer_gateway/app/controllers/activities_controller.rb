class ActivitiesController < ApplicationController
  def index
    @activities = mq_request 'activity.index', 'activity.indexed', {}
    render json: @activities
  end

  def show
    @activity = mq_request 'activity.show', 'activity.showed', id: params[:id]
    render json: @activity
  end

  def create
    @activity = mq_request 'activity.create', 'activity.created', activity: activity_params
    render json: @activity, status: :created
  end

  def update
    @activity = mq_request 'activity.update', 'activity.updated', activity: activity_params, id: params[:id]
    render json: @activity, status: :created
  end

  def destroy
    mq_request 'wfms.activity.destroy', 'wfms.activity.destroyed', id: params[:id]
    head :no_content
  end

  private

  def activity_params
    params.require(:activity).permit(:id, :subactivity_id, :process_definition_id, :activity_type, :input_schema, :output_schema, :activity_configuration, :representation, :subworkflow_id, :participant_role_id ).tap do |whitelisted|
      whitelisted[:representation] = params[:activity][:representation]
      whitelisted[:input_schema]   = params[:activity][:input_schema]
      whitelisted[:output_schema]  = params[:activity][:output_schema]
      whitelisted[:activity_configuration] = params[:activity][:activity_configuration]
    end
  end
end

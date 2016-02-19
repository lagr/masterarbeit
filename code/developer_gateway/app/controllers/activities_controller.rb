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
    @activity.update_attributes(activity_params)

    if @activity.save
      head :no_content
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @activity.destroy

    head :no_content
  end

  def export
    redirect_to @activity, notice: 'Exported'
  end

  def start_instance
    redirect_to @activity, notice: 'Started'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:id, :subworkflow_id, :process_definition_id, :activity_type, :input_schema, :output_schema,
              :activity_configuration, :representation)
    end
end

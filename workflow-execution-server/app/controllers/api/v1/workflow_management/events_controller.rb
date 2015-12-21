class Api::V1::WorkflowManagement::EventsController < Api::ApiController

  def create
    @event = Event.new(
      data: JSON.parse(URI.decode(params['data'])),
      subject_id: params['subject_id'], 
      subject_type: params['subject_type'])

    logger.debug "#{@event.subject_type}:#{@event.subject_id} : #{@event.data}"

    if @event.save!
      render json: {object: @event}, status: :ok
    else
      render json: {}, status: :error
    end
  end

  private
  def render_error(error)
    render :json => {:error => error.message}, :status => :error
  end 
end

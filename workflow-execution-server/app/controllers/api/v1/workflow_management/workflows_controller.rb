class Api::V1::WorkflowManagement::WorkflowsController < Api::ApiController
  def index
    @workflows = Workflow.all
    render json: @workflows
  end

  def install
    @images = images_from_params
    if ImageManager.install(@images)
      render json: params, status: 202
    else
      respond_with_error
    end
  end

  def uninstall
    @images = images_to_uninstall

    if ImageManager.uninstall(@images)
      respond_with_ok
    else
      respond_with_error
    end
  end

  private

  def images_from_params
    workflows = JSON.parse(params[:workflows])
    images = workflows.collect(&:image)
    images += workflows.collect{ |wf| wf['activities'] }.flatten.collect{ |a| a['image'] }
  end
end

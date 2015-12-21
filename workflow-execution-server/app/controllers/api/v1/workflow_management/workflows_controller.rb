class Api::V1::WorkflowManagement::WorkflowsController < Api::ApiController
  def index
    @workflows = Workflow.all
    render json: @workflows
  end

  def install
    @images = images_to_install
    installation_successful = ImageManager.install(@images)
    if installation_successful
      render json: params, status: 202
    else
      respond_with_error
    end
  end

  def uninstall
    @image = images_to_uninstall
    uninstallation_successful = ImageManager.uninstall(@image)
    if uninstallation_successful
      respond_with_ok
    else
      respond_with_error
    end
  end

  private

  def images_to_install
  end

  def images_to_uninstall
  end
end

class ServersController < ApplicationController
  #rescue_from ImageGenerationException, with: :image_generation_error_response

  def index
    @servers = if params[:role].present? 
      case params[:role] 
      when 'repository'
        Server.repositories
      when 'execution_environment'
        Server.execution_servers
      end
    else
      Server.where.not(role: 'repository')
    end
    render json: @servers
  end

  def show
    render json: Server.find(params[:id])
  end

  def status
    @server = Server.find(params[:id])
    connector = ExecutionServerConnector.new(@server)

    status = { 
      reachable: connector.reachable?, 
      docker_available: connector.docker_available?,
      execution_environment_available: connector.execution_environment_available?
    }
    puts ap server: @server, status: status
    render json: status 
  end

  def index_images
    @server = Server.find(params[:id])
    connector = ExecutionServerConnector.new(@server)

    render json: {
      required: @server.required_images,
      installed: connector.installed_images
    }
  end

  def deploy_workflow_bundles
    @server = Server.find(params[:id])
    connector = ExecutionServerConnector.new(@server)

    @workflows = 
      #WorkflowBundle.where(id: params[:workflow_bundle_ids]).collect(&:workflows) ||
      @server.workflows

    create_required_images

    if connector.deploy(@workflows)
      render json: {}, status: :ok
    else
      render json: {}, status: :error
    end
  end

  def create
    if @server = Server.create
      render json: @server
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def destroy
    @server = Server.find(params[:id])
    if @server.destroy
      render json: @server, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  private

  def create_required_images
    failed_images = []
    @workflows.each do |workflow|
      workflow_images = ImageManager.create_workflow_image(workflow) 
      activity_images = ImageManager.create_activity_images(workflow.process_elements)

      failed_images += workflow_images[:failed]
      failed_images += activity_images[:failed]
    end

    raise ImageGenerationException unless failed_images.empty?
  end 

  def successful?(status_codes)
    status_codes.all? { |r| r.to_s.first == '2' }
  end
end

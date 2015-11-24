class ServersController < ApplicationController
  def index
    if params[:role].present? and params[:role] == 'repository'
      render json: Server.repositories
    else
      render json: Server.all
    end
  end

  def show
    render json: Server.find(params[:id])
  end

  def index_images
    @server = Server.find(params[:id])
    render json: {
      required: @server.required_images,
      installed: @server.installed_images
    }
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
end

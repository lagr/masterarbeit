class ServersController < ApplicationController
  def index
    render json: @servers = Server.all
  end

  def show
    @server = Server.find(params[:name])
    render json: @server
  end
end

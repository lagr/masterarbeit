class ServersController < ApplicationController

  # GET /servers
  # GET /servers.json
  def index
    render json: @servers = Server.all
  end

  # GET /servers/development-machine
  # GET /servers/development-machine.json
  def show
    @server = Server.find(params[:name])
    render json: @server
  end
end

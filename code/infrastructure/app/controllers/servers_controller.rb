class ServersController < ApplicationController

  # GET /servers
  # GET /servers.json
  def index
    @servers = EnvironmentManager.all_servers
    render json: @servers
  end

  # GET /servers/development-machine
  # GET /servers/development-machine.json
  def show
    @server = EnvironmentManager.all_servers.detect {|s| s.name == params[:name] }
    @server.containers = EnvironmentManager.containers(@server)
    @server.images = EnvironmentManager.images(@server)
    puts @server
    render json: @server
  end
end

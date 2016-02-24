class ServersController < ApplicationController
  def index
    @servers = EnvironmentManager.all_servers
    render json: @servers
  end

  def show
    @server = EnvironmentManager.all_servers.detect {|s| s.name == params[:name] }
    @server.containers = EnvironmentManager.containers(@server)
    @server.images = EnvironmentManager.images(@server)
    puts @server
    render json: @server
  end
end

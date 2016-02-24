class ServersController < ApplicationController
  def index
    @servers = mq_request 'server.index', 'server.indexed', {}
    render json: @servers
  end

  def show
    @server = mq_request 'server.show', 'server.showed', name: params[:name]
    render json: @server
  end
end

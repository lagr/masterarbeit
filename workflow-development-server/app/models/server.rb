require 'net/ping'
Net::Ping::TCP.service_check = true       # interpret actively refused connection as signal for running server

class Server < ActiveRecord::Base
  validates_presence_of :ip, :docker_port
  DEFAULT_REQUIRED_IMAGES = [
    { name: 'alpine:3.2' }
  ].freeze

  attr_accessor :docker_connection
  # def initialize(*args)
  #   docker_connection = Docker::Connection.new("tcp://#{ip}:#{docker_port}", {})
  #   super()
  # end

  scope :repositories,      ->{ where(role: 'repository') }
  scope :enactment_servers, ->{ where(role: 'enactment') }

  def reachable?
    Net::Ping::TCP.new(ip).ping?
  end

  def docker_available?
    Docker.version if name == 'localhost'
    #name == 'localhost' ? Docker.version : Docker.version(docker_connection)
  end

  def required_images
    DEFAULT_REQUIRED_IMAGES
    # workflow_bundles.required_images
  end

  def installed_images
    Docker::Image.all
  end
end

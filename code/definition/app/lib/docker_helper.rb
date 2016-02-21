require 'resolv'
module DockerHelper
  extend self
  DEFAULT_DOCKER_PORT = 2376

  def registry_address
    cluster_store = URI.parse(Docker.info['ClusterStore'])
    cluster_store.port = 5000
    cluster_store.select(:host,:port).join(':')
  end

  def local_docker_connection
    Docker::Connection.new('unix:///var/run/docker.sock', {})
  end
end

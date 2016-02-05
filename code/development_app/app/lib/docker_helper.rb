require 'resolv'
module DockerHelper
  extend self
  SHORT_TYPES = { activity: 'ac', workflow: 'wf' }.freeze
  DEFAULT_DOCKER_PORT = 2376
  CERT_PATH = "#{ENV['SWARM_MANAGER_CERT_PATH']}"

  def registry_address
    cluster_store = URI.parse(Docker.info['ClusterStore'])
    cluster_store.port = 5000
    cluster_store.select(:host,:port).join(':')
  end

  def image_name(type:, id: 'base')
    "#{SHORT_TYPES[type]}_#{id}"
  end

  def local_docker_connection
    Docker::Connection.new('unix:///var/run/docker.sock', {})
  end

  def tls_options
    {
      client_cert: File.join(CERT_PATH, 'cert.pem'),
      client_key: File.join(CERT_PATH, 'key.pem'),
      ssl_ca_file: File.join(CERT_PATH, 'ca.pem'),
      scheme: 'https'
    }
  end

  def swarm_manager_connection
    swarm_manager_url = URI.parse('tcp://' + Docker.info['ClusterAdvertise'])
    swarm_manager_url.port = 3376
    Docker::Connection.new swarm_manager_url.to_s, tls_options
  end

  def docker_connection(server)
    docker_port = server.server_configuration.try(:[], 'docker_port') || DEFAULT_DOCKER_PORT
    Docker::Connection.new "tcp://#{server.ip}:#{docker_port}", tls_options
  end
end

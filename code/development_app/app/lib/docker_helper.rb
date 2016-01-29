require 'resolv'
module DockerHelper
  extend self
  SHORT_TYPES = { activity: 'ac', workflow: 'wf' }.freeze
  DEFAULT_DOCKER_PORT = 2376
  CERT_PATH = "#{ENV['SWARM_MANAGER_CERT_PATH']}"
  SWARM_MANAGER_URL = "#{ENV['SWARM_MANAGER_URL']}"

  def registry_ip
    Resolv.getaddress 'registry_service_1'
  end

  def image_name(type:, id: 'base')
    "#{SHORT_TYPES[type]}_#{id}"
  end

  def local_docker_connection
    Docker::Connection.new('unix:///var/run/docker.sock', {})
  end

  def swarm_manager_connection
    Docker::Connection.new(SWARM_MANAGER_URL, {})
  end

  def docker_connection(server)
    docker_port = server.server_configuration.try(:[], 'docker_port') || DEFAULT_DOCKER_PORT
    Docker::Connection.new "tcp://#{server.ip}:#{docker_port}", {
      client_cert: File.join(CERT_PATH, 'cert.pem'),
      client_key: File.join(CERT_PATH, 'key.pem'),
      ssl_ca_file: File.join(CERT_PATH, 'ca.pem'),
      scheme: 'https'
    }
  end
end

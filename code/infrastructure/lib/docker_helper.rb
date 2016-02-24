module DockerHelper
  extend self
  DEFAULT_DOCKER_PORT = 2376
  CERT_PATH = "#{ENV['SWARM_MANAGER_CERT_PATH']}"

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
    Docker::Connection.new "tcp://#{server.ip}:#{DEFAULT_DOCKER_PORT}", tls_options
  end
end

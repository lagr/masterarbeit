Docker.url = "#{ENV['SWARM_MANAGER_URL']}"
cert_path = "#{ENV['SWARM_MANAGER_CERT_PATH']}"
Docker.options = {
  client_cert: File.join(cert_path, 'cert.pem'),
  client_key: File.join(cert_path, 'key.pem'),
  ssl_ca_file: File.join(cert_path, 'ca.pem'),
  scheme: 'https'
}
module WorkflowEngine
  module DockerHelper
    extend self
    SHORT_TYPES = { activity: 'ac', workflow: 'wf' }.freeze
    DEFAULT_DOCKER_PORT = 2376
    CERT_PATH = "#{ENV['SWARM_MANAGER_CERT_PATH']}"
    SWARM_MANAGER_URL = "#{ENV['SWARM_MANAGER_URL']}"

    def image_name(type:, id: 'base')
      "#{SHORT_TYPES[type]}_#{id}"
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
end


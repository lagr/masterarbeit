module WorkflowEngine
  module DockerHelper
    extend self
    SHORT_TYPES = { activity: 'ac', workflow: 'wf' }.freeze

    cert_path = "#{ENV['SWARM_MANAGER_CERT_PATH']}"
    swarm_manager_url = URI.parse('tcp://' + Docker.info['ClusterAdvertise'])
    swarm_manager_url.port = 3376

    Docker.url = swarm_manager_url.to_s
    Docker.options = {
      client_cert: File.join(cert_path, 'cert.pem'),
      client_key: File.join(cert_path, 'key.pem'),
      ssl_ca_file: File.join(cert_path, 'ca.pem'),
      scheme: 'https'
    }

    def image_name(type:, id: 'base')
      "#{SHORT_TYPES[type]}_#{id}"
    end

    def local_conenction
      Docker::Connection.new "unix:///var/run/docker.sock", {}
    end
  end
end


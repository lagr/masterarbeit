module EnvironmentManager
  extend self

  DEFAULT_DOCKER_PORT = 2376
  DEFAULT_CONSUL_PORT = 8500
  CONSUL_URL = "http://192.168.99.188:#{DEFAULT_CONSUL_PORT}"
  CERT_PATH = "#{ENV['SWARM_MANAGER_CERT_PATH']}"

  def unmanaged_servers(managed_servers)
    managed_servers_ips = managed_servers.map(&:ip)
    available_servers.reject { |s| managed_servers_ips.include?(s.ip) }
  end

  def managed_servers
    Server.all
  end

  def available_servers
    servers = []
    swarm_image.run(['list', 'consul://192.168.99.188:8500']).streaming_logs(stdout: true) do |stream, entry|
      entry_parts = entry.split(':')
      servers << Server.new(ip: entry_parts[0])
    end
    servers
  end

  private

  def swarm_image
    @swarm_image ||= Docker::Image.get('swarm')
  end

  def server_docker_connection(server)
    docker_port = server.server_configuration['docker_port'] || DEFAULT_DOCKER_PORT
    Docker::Connection.new "tcp://#{server.ip}:#{docker_port}", {
      client_cert: File.join(CERT_PATH, 'cert.pem'),
      client_key: File.join(CERT_PATH, 'key.pem'),
      ssl_ca_file: File.join(CERT_PATH, 'ca.pem'),
      scheme: 'https'
    }))
  end
end

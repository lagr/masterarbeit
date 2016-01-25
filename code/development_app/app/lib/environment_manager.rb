module EnvironmentManager
  extend self
  DEFAULT_CONSUL_PORT = 8500
  CONSUL_URL = "http://192.168.99.193:#{DEFAULT_CONSUL_PORT}"

  def unmanaged_servers(managed_servers)
    managed_servers_ips = managed_servers.map(&:ip)
    available_servers.reject { |s| managed_servers_ips.include?(s.ip) }
  end

  def managed_servers
    Server.all
  end

  def available_servers
    servers = []
    container = swarm_image.run(['list', 'consul://192.168.99.100:8500']).streaming_logs(stdout: true) do |stream, entry|
      entry_parts = entry.split(':')
      servers << Server.new(ip: entry_parts[0])
    end

    container.delete
    servers
  end

  def index_containers(server, status = :all)
    filters = status == :all? ? {} : { status: ["#{status}"] }
    Docker::Container.all({all: true, filters: filters.to_json}, DockerHelper.docker_connection(server))
  end

  def index_images(server)
    Docker::Image.all({all: true, filters: { dangling: [false] } }.to_json, DockerHelper.docker_connection(server))
  end

  private

  def swarm_image
    @swarm_image ||= Docker::Image.get('swarm')
  end
end

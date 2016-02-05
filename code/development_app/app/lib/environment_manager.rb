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
    swarm_info = Docker.info(DockerHelper.swarm_manager_connection)
    raw_servers = swarm_info['DriverStatus'].select { |pairs| ip?(pairs[1]) }
    servers = raw_servers.collect { |raw| Server.new(ip: remove_port(raw[1]), name: raw[0]) }
  end

  def index_containers(server, status = :all)
    filters = status == :all? ? {} : { status: ["#{status}"] }
    Docker::Container.all({all: true, filters: filters.to_json}, DockerHelper.docker_connection(server))
  end

  def index_images(server)
    Docker::Image.all({all: true, filters: { dangling: [false] } }.to_json, DockerHelper.docker_connection(server))
  end

  private

  def ip?(string)
    remove_port(string) =~ Resolv::IPv4::Regex
  end

  def remove_port(ip)
    ip.remove(/:\d+$/)
  end
end

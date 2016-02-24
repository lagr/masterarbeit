module EnvironmentManager
  extend self

  def all_servers
    swarm_info = Docker.info(DockerHelper.swarm_manager_connection)
    raw_servers = swarm_info['DriverStatus'].select { |pairs| ip?(pairs[1]) }
    servers = raw_servers.collect { |raw| Server.new(ip: remove_port(raw[1]), name: raw[0]) }
  end

  def containers(server, status = :all)
    filters = status == :all ? {} : { status: ["#{status}"] }
    Docker::Container.all({all: true, filters: filters.to_json}, DockerHelper.docker_connection(server))
  end

  def images(server)
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

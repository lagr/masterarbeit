module EnvironmentManager
  extend self

  def all_servers
    swarm_info = Docker.info(DockerHelper.swarm_manager_connection)
    raw_servers = swarm_info['DriverStatus'].select { |pairs| ip?(pairs[1]) }
    servers = raw_servers.collect do |raw|
      Server.new(ip: remove_port(raw[1]), name: raw[0])
    end
  end

  def containers(server, status = :all)
    filters = status == :all ? {} : { status: ["#{status}"] }
    Docker::Container.all(
      {all: true, filters: filters.to_json},
      DockerHelper.docker_connection(server)
    )
  end

  def images(server)
    Docker::Image.all(
      {all: true, filters: { dangling: [false] } }.to_json,
      DockerHelper.docker_connection(server)
    )
  end

  def watch_for_new_nodes
    begin
      Docker::Event.stream do |event|
        if event.status == 'engine_connect'
          server = Server.new(name: event.from.gsub('swarm node:', ''), ip: nil)
          start_provisioner(server_name)
        end
      end
    rescue
      retry
    end
  end

  private

  def start_provisioner(server)
    provisioner = Docker::Container.create({
      'name' => "provisioner-#{server.name}",
      'Image' => "provisioner",
      'Cmd' => [''],
      'HostConfig' => {'Binds'=>['/var/run/docker.sock:/var/run/docker.sock']},
      'Env' => ["constraint:node==#{server.name}"],
      'AttachStdin' => false, 'AttachStdout' => false, 'AttachStderr' => false,
      'Tty' => true
    }, DockerHelper.swarm_manager_connection)

    Docker::Network.get('wfms_backend', DockerHelper.swarm_manager_connection)
      .connect("provisioner-#{server.name}")

    provisioner.start
  end

  def ip?(string)
    remove_port(string) =~ Resolv::IPv4::Regex
  end

  def remove_port(ip)
    ip.gsub(/:\d+$/, '')
  end
end

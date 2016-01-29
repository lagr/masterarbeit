module DeploymentManager
  extend self

  def setup_environment(server)
    create_gem_container
  end

  def adapt_environment(server)
    install_required_images
    start_environment_containers
  end

  def install_required_images(server)
  end

  def start_environment_containers(server)
  end

  def create_gem_container(server)
    gem_container = Docker::Container.create({
      'name' => "gem_data_#{server.name}",
      'Image' => 'cogniteev/echo',
      'Cmd' => ['echo', "Data container for #{server.name}"],
      'HostConfig' => {
        'Binds' => ["/usr/local/bundle:/usr/local/bundle"]
      },
      'Env' => [
        "constraint:node==#{server.name}"
      ]
    }).refresh!.tap(&:start)
  end
end

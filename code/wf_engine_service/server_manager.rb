module WorkflowEngine
  module ServerManager
    extend self

    def prepare(server:)
      create_gem_container(server[:name])
    end



    private

    def create_gem_container(server_name)
      return if Docker::Container.exist? "gem_data_#{server_name}"
      Docker::Container.create({
        'name' => "gem_data_#{server_name}",
        'Image' => 'cogniteev/echo',
        'Cmd' => ['echo', "Gem container for #{server_name}"],
        'HostConfig' => {'Binds' => ["/usr/local/bundle:/usr/local/bundle"]},
        'Env' => [ "constraint:node==#{server_name}"]
      }).refresh!.tap(&:start)
    end
  end
end

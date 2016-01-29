module WorkflowEngine
  class WorkflowInstance
    def initialize(workflow_id, target_node)
      @workflow_id = workflow_id
      @target_node = target_node

      @input_data  = input_data
      @instance_id = SecureRandom.uuid

      @data_container = create_data_container
      @instance_container = create_instance_container.refresh!

      copy_input_data_to_container
      connect_instance_to_enactment_network
    end

    def create_instance_container
      instance_container = Docker::Container.create({
        'name' => "wfi_#{@instance_id}",
        'Image' => "192.168.99.100:5000/#{DockerHelper.image_name(type: :workflow, id: @workflow_id)}",
        'Cmd' => ['bash'],
        'WorkingDir' => '/workflow',
        'Tty' => true,
        'HostConfig' => {
          'Binds' => ['/var/run/docker.sock:/var/run/docker.sock'],
          'VolumesFrom' => [
            @data_container.info['Name'],
            "gem_data_#{@target_node}"
            ],
        },
        'Env' => [
          "affinity:container==#{@data_container.id}",
          "MAIN_WORKFLOW_ID=#{@workflow_id}",
          "WORKFLOW_ID=#{@workflow_id}",
          "INSTANCE_ID=#{@instance_id}",
          "GEM_DATA_CONTAINER=gem_data_#{@target_node}",
        ]
      })
    end
  end
end

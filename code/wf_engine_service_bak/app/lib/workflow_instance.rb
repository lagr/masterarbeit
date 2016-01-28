class WorkflowInstance
  attr_accessor :instance_container, :data_container
  def initialize(workflow_id, input_data, target_node )
    @workflow_id = workflow_id
    @target_node = target_node

    @input_data  = input_data
    @instance_id = SecureRandom.uuid

    @data_container = create_data_container
    @instance_container = create_instance_container.refresh!

    copy_input_data_to_container
    connect_instance_to_enactment_network
  end

  def run
    @instance_container.tap do |c|
      c.start
      c.exec ['ruby', '/workflow/run.rb']
      result = c.copy "/workflow_relevant_data/#{@instance_id}/"
      c.stop
    end
    result
  end

  def delete
    @instance_container.delete(:force => true)
  end

  private

  def create_data_container
    data_container = Docker::Container.create({
      'name' => "data_#{@instance_id}",
      'Image' => 'cogniteev/echo',
      'Cmd' => ['echo', "Data container for #{@instance_id}"],
      'HostConfig' => {
        'Binds' => ["/workflow_relevant_data/#{@instance_id}:/workflow_relevant_data"]
      },
      'Env' => [
        "constraint:node==#{@target_node}"
      ]
    })

    data_container.refresh!.tap(&:start)
  end

  def copy_input_data_to_container
    @instance_container.start
    #@instance_container.exec(['echo', @input_data.to_json, '>>', '/workflow/input.data.json'], {tty: true})
    @instance_container.stop
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

  def connect_instance_to_enactment_network
    @instance_container.start
    Docker::Network.get('enactment_net').connect(@instance_container.id)
    @instance_container.stop
  end
end

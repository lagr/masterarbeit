require 'pry'
module WFMS
  class WorkflowInstance
    attr_accessor :instance_container, :data_container, :instance_id
    def initialize(workflow_id, input_data, target_node )
      @workflow_id = workflow_id
      @target_node = target_node
      @input_data  = input_data
      @instance_id = SecureRandom.uuid
    end

    def run
      Docker::Network.get('wfms_enactment').connect(@instance_container.id)
      @instance_container.start
      @instance_container.pause
      copy_input_data_to_container
      @instance_container.unpause
      @instance_container.wait
      copy_output_data_from_container
      #@instance_container.delete(:force => true)
    end

    private

    def copy_input_data_to_container
      Dir.mktmpdir do |tmpdir|
        File.open("#{tmpdir}/input.data.json", "w"){ |i| i.write(@input_data.to_json) }
        @instance_container.archive_in ["#{tmpdir}/input.data.json"], "/workflow"
      end
    end

    def create_instance_container
      instance_container = Docker::Container.create({
        'name' => "wfi_#{@instance_id}",
        'Labels' => {"wfi_#{@instance_id}" => ""},
        'Image' => "192.168.99.100:5000/workflow:#{DockerHelper.image_name(type: :workflow, id: @workflow_id)}",
        'Cmd' => ['bash'],
        'WorkingDir' => '/workflow',
        'Tty' => true,
        'HostConfig' => {
          'Binds' => ['/var/run/docker.sock:/var/run/docker.sock'],
          'VolumesFrom' => [@data_container.info['Name']],
        },
        'Env' => [
          "affinity:container==#{@data_container.id}",
          "MAIN_WORKFLOW_ID=#{@workflow_id}",
          "WORKFLOW_ID=#{@workflow_id}",
          "INSTANCE_ID=#{@instance_id}"
        ]
      })
    end
  end
end

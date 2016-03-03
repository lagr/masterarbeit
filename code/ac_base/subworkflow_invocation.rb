require 'docker-api'

module Activity
  class SubworkflowInvocation
    def initialize(config)
      @config = config
      @registry = Activity::Configuration.image_registry
      @image_tag = "#{config['image']}:#{config['image_version']}"
      @container_name = "#{Activity::Configuration.container_name}_#{config['image']}"
      @container = create_container

      @instance_id = SecureRandom.uuid
    end

    def start
      @container.start
      @container.wait(60 * 60)
    end

    def result
      {
        container_out: @container.logs(stdout: true),
        container_err: @container.logs(stderr: true)
      }
    end

    private

    def registry_address
      cluster_store = URI.parse(Docker.info['ClusterStore'])
      cluster_store.port = 5000
      cluster_store.select(:host,:port).join(':')
    end

    def create_container

      Docker::Container.create({
        'name' => "wfi_#{@instance_id}",
        'Labels' => {
          "main_workflow_instance" => "#{Activity::Configuration.main_workflow_instance_id}",
          "workflow_instance" => "wfi_#{@instance_id}",
        },
        'Image' => "#{registry_address}/workflow:wf_#{@subworkflow_id)}",
        'Cmd' => ['bash'],
        'WorkingDir' => '/workflow',
        'Tty' => true,
        'HostConfig' => {
          'Binds' => ['/var/run/docker.sock:/var/run/docker.sock'],
          'VolumesFrom' => [Activity::Configuration.workflow_relevant_data_container],
        },
        'Env' => [
          "affinity:container==#{@data_container.id}",
          "MAIN_WORKFLOW_ID=#{@workflow_id}",
          "MAIN_WORKFLOW_INSTANCE_ID=#{@instance_id}",
          "WORKFLOW_ID=#{@workflow_id}",
          "INSTANCE_ID=#{@instance_id}",
          "WORKDIR=#{Activity::FileHelper.activity_instance_workdir(self)}"
        ]
      })
    end
  end
end

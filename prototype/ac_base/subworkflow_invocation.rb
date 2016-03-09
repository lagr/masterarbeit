require 'docker-api'

module Activity
  class SubworkflowInvocation
    def initialize(config)
      @instance_id = SecureRandom.uuid
      @subworkflow_id = config['subworkflow_id']

      @container_workdir = prepare_workdir
      @container = create_container
      @container.archive_in [Activity::FileHelper.input_data], "/workflow"
    end

    def start
      Docker::Network.get('wfms_enactment').connect(@container.id)
      @container.start
      begin
        @container.wait(60 * 60)
      rescue TimeoutError => e
        retry
      end
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

    def prepare_workdir
      Activity::FileHelper.create_subworkflow_workdir @instance_id
    end

    def create_container

      Docker::Container.create({
        'name' => "wfi_#{@instance_id}",
        'Labels' => {
          "main_workflow_instance" => "#{Activity::Configuration.main_workflow_instance_id}",
          "workflow_instance" => "wfi_#{@instance_id}",
        },
        'Image' => "#{registry_address}/workflow:wf_#{@subworkflow_id}",
        'Cmd' => ['bash'],
        'WorkingDir' => '/workflow',
        'Tty' => true,
        'HostConfig' => {
          'Binds' => ['/var/run/docker.sock:/var/run/docker.sock'],
          'VolumesFrom' => [Activity::Configuration.workflow_relevant_data_container],
        },
        'Env' => [
          "MAIN_WORKFLOW_ID=#{@workflow_id}",
          "MAIN_WORKFLOW_INSTANCE_ID=#{@instance_id}",
          "WORKFLOW_ID=#{@workflow_id}",
          "INSTANCE_ID=#{@instance_id}",
          "WORKDIR=#{@container_workdir}",
          "DATA_CONTAINER=#{Activity::Configuration.workflow_relevant_data_container}"
        ]
      })
    end
  end
end

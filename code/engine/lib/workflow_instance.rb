require 'pry'
module WorkflowEngine
  class WorkflowInstance
    attr_accessor :instance_container, :data_container, :instance_id
    def initialize(workflow_id, input_data)
      @workflow_id = workflow_id
      @input_data  = input_data
      @instance_id = SecureRandom.uuid

      @data_container = create_data_container
      @instance_container = create_instance_container.refresh!
    end

    def start
      Docker::Network.get('wfms_enactment').connect(@instance_container.id)
      @instance_container.start

      @instance_container.pause
      copy_input_data_to_container
      @instance_container.unpause

      begin
        @instance_container.wait
      rescue
        retry
      end
      copy_output_data_from_container
      # @instance_container.delete(:force => true) # deactivated for the prototype
    end

    private

    def random_constraint
      [
        "constraint:edu.proto.machine_env==external",
        "constraint:edu.proto.ram==/(\\d\\d\\d\\d+|[7-9]\\d\\d|[6][5-9]\\d)/"
      ].sample
    end

    def create_data_container
      Docker::Container.create({
        'name' => "data_#{@instance_id}",
        'Labels' => {
          "main_workflow_instance" => "wfi_#{@instance_id}"
        },
        'Image' => 'cogniteev/echo',
        'Cmd' => ['echo', "Data container for #{@instance_id}"],
        'HostConfig' => {'Binds' => ["/workflow_relevant_data/#{@instance_id}:/workflow_relevant_data"]},
        'Env' => [ random_constraint ]
      }).refresh!.tap(&:start)
    end

    def copy_output_data_from_container
      result = @instance_container.archive_out("/workflow_relevant_data/output/input.data.json") do |archive|
        pseudo_io = StringIO.new(archive)
        data_file = Gem::Package::TarReader.new(pseudo_io).first
        JSON.parse(data_file.read)
      end
      result ||= nil
    end

    def copy_input_data_to_container
      Dir.mktmpdir do |tmpdir|
        File.open("#{tmpdir}/input.data.json", "w"){ |i| i.write(@input_data.to_json) }
        @instance_container.archive_in ["#{tmpdir}/input.data.json"], "/workflow"
      end
    end

    def registry_address
      docker_info = Docker.info(DockerHelper.local_conenction)
      cluster_store = URI.parse(docker_info['ClusterStore'])
      cluster_store.port = 5000
      cluster_store.select(:host,:port).join(':')
    end

    def create_instance_container
      Docker::Container.create({
        'name' => "wfi_#{@instance_id}",
        'Labels' => {
          "main_workflow_instance" => "wfi_#{@instance_id}",
          "workflow_instance" => "wfi_#{@instance_id}",
        },
        'Image' => "#{registry_address}/workflow:#{DockerHelper.image_name(type: :workflow, id: @workflow_id)}",
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
          "MAIN_WORKFLOW_INSTANCE_ID=#{@instance_id}",
          "WORKFLOW_ID=#{@workflow_id}",
          "INSTANCE_ID=#{@instance_id}"
        ]
      })
    end
  end
end

require 'docker-api'

module Activity
  class ContainerInvocation
    def initialize(config)
      @config = config
      @registry = Activity::Configuration.image_registry
      @image_tag = "#{config['image']}:#{config['image_version']}"
      @container_name = "#{Activity::Configuration.container_name}_container"
      @container = create_container
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

    def create_container
      Docker::Container.create({
        'name' => @container_name,
        'Image' => "#{@registry}/#{@image_tag}",
        'Cmd' => @config['cmd'].split(' '),
        'Labels' => {
          "main_workflow_instance" => "#{Activity::Configuration.main_workflow_instance_id}",
          "workflow_instance" => "#{Activity::Configuration.workflow_instance_id}",
          "activity_instance" => "#{Activity::Configuration.activity_instance_id}",
        },
      })
    end
  end
end

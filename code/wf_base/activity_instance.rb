require 'securerandom'

module Workflow
  class ActivityInstance
    attr_accessor :activity, :completed_predecessors, :id

    def initialize(activity)
      @id = SecureRandom.uuid
      @activity = activity
      @completed_predecessors = []
      @completed = false
    end

    def completed?
      @completed
    end

    def required_predecessors_completed?
      return true if @activity.type == 'start'
      return true if @activity.type == "orjoin" && @completed_predecessors.length > 0
      return true if @completed_predecessors.length > 0

      completed_predecessors_activity_ids = @completed_predecessors.map(&:activity).collect(&:id)
      (@activity.predecessors.collect(&:id) - completed_predecessors_activity_ids).empty?
    end

    def run
      container.tap do |c|
        c.start

        c.pause
        Docker::Network.get(Workflow::Configuration.network).connect(c.id)
        Docker::Network.get('enactment_net').connect(c.id)
        c.unpause

        c.wait(60 * 60)
        c.delete unless Workflow::Configuration.keep_activity_containers?
      end
      @completed = true
    end

    def container
      config = Workflow::Configuration

      Docker::Container.create({
        'name' => "aci_#{@id}",
        'Labels' => {
          "wfi_#{@instance_id}" => "",
          "aci_#{@id}" => ""
        },
        'Image' => "#{config.image_registry}/ac_#{@activity.id}",
        'Cmd' => [''],
        'WorkingDir' => '/activity',
        'Tty' => true,
        'Env' => [
          "MAIN_WORKFLOW_ID=#{config.main_workflow_id}",
          "WORKFLOW_ID=#{config.workflow_id}",
          "WORKFLOW_INSTANCE_ID=#{config.workflow_instance_id}",
          "WORKDIR=#{Workflow::FileHelper.activity_instance_workdir(self)}",
          "ACTIVITY_ID=#{@activity.id}",
          "ACTIVITY_INSTANCE_ID=#{@id}"
        ],
        'HostConfig' => {
          'Binds' => ['/var/run/docker.sock:/var/run/docker.sock'],
          'VolumesFrom' => [
            config.workflow_relevant_data_container,
            #config.gem_data_container
          ],
        }
      })
    end
  end
end

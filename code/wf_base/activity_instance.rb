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
        Docker::Network.get(Workflow::Configuration.network).connect(c.id)
        Docker::Network.get('wfms_enactment').connect(c.id)
        c.start
        c.wait(60 * 60)
        Docker::Network.get(Workflow::Configuration.network).disconnect(c.id)
        Docker::Network.get('wfms_enactment').disconnect(c.id)
        c.delete unless Workflow::Configuration.keep_activity_containers?
      end
      @completed = true
    end

    def container
      config = Workflow::Configuration

      Docker::Container.create({
        'name' => "aci_#{@id}",
        'Labels' => {
          "main_workflow_instance" => "#{config.main_workflow_instance_id}",
          "workflow_instance" => "#{config.workflow_instance_id}",
          "activity_instance" => "#{@id}",
        },
        'Image' => "#{config.image_registry}/activity:ac_#{@activity.id}",
        'Cmd' => [''],
        'WorkingDir' => '/activity',
        'Tty' => true,
        'Env' => [
          "MAIN_WORKFLOW_ID=#{config.main_workflow_id}",
          "MAIN_WORKFLOW_INSTANCE_ID=#{config.main_workflow_instance_id}",
          "WORKFLOW_ID=#{config.workflow_id}",
          "WORKFLOW_INSTANCE_ID=#{config.workflow_instance_id}",
          "ACTIVITY_ID=#{@activity.id}",
          "ACTIVITY_INSTANCE_ID=#{@id}",
          "WORKDIR=#{Workflow::FileHelper.activity_instance_workdir(self)}",
          "DATA_CONTAINER=#{config.workflow_relevant_data_container}"
        ],
        'HostConfig' => {
          'Binds' => ['/var/run/docker.sock:/var/run/docker.sock'],
          'VolumesFrom' => [config.workflow_relevant_data_container],
        }
      })
    end
  end
end

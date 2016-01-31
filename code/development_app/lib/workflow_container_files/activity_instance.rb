require 'aasm'
require 'securerandom'

module Workflow
  class ActivityInstance
    include AASM

    attr_accessor :activity, :completed_predecessors, :state, :id, :container

    def initialize(activity)
      @id = SecureRandom.uuid
      @activity = activity
      @completed_predecessors = []
      @container = nil
    end

    def required_predecessors_completed?
      return true if @activity.predecessors.empty?
      return true if @activity.type == "orjoin" && @completed_predecessors.length > 0
      return true if @completed_predecessors.length > 0
      completed_predecessors_activity_ids = @completed_predecessors.map(&:activity).collect(&:id)
      (@activity.predecessors.collect(&:id) - completed_predecessors_activity_ids).empty?
    end

    aasm do
      after_all_transitions :log_status_change

      state :inactive
      state :active
      state :suspended
      state :completed

      event :suspend do
        transitions from: [:active, :inactive], to: :suspended
      end

      event :resume do
        transitions from: :suspended, to: :inactive
      end

      event :activate do
        transitions from: :inactive, to: :active
      end

      event :complete do
        transitions from: :active, to: :completed
      end
    end

    def log_status_change
    end

    def start
      @container.tap do |c|
        c.start
        c.exec ['ruby', '/activity/run.rb']
        c.stop
        #c.delete
      end
    end

    def create_container
      config = Workflow::Configuration

      @container = Docker::Container.create({
        'name' => "aci_#{@id}",
        'Image' => "#{config.image_registry}/ac_#{@activity.id}",
        'Cmd' => ['bash'],
        'WorkingDir' => '/activity',
        'Tty' => true,
        'Env' => [
          "MAIN_WORKFLOW_ID=#{config.main_workflow_id}",
          "WORKDIR=#{Workflow::FileHelper.activity_instance_workdir(self)}"
        ],
        'HostConfig' => {
          'Binds' => ['/var/run/docker.sock:/var/run/docker.sock'],
          'VolumesFrom' => [
            config.workflow_relevant_data_container,
            # todo add gem data
            # config.gem_data_container
          ],
        }
      })

      @container.start
      Docker::Network.get('enactment_net').connect(@container.id)
      @container.stop
    end
  end
end

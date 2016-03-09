module Workflow
  class ProcessInstance
    def initialize
      @process_definition = Workflow::ProcessDefinition.new
      @queue = []
      @activity_instances = {}

      Workflow::FileHelper.ensure_workflow_input_dir

      Workflow::Validator.new(
        schema: Workflow::Configuration.input_schema,
        data: Workflow::Configuration.input_data
      ).validate
    end

    def start
      start_activity_instance = find_or_create_activity_instance(start_activity)
      Workflow::FileHelper.link_workflow_input_to_start_activity_instance_input(
        start_activity_instance
      )

      loop do
        break if @queue.compact.empty?
        process_queued_activity_instances
      end
    end

    def process_queued_activity_instances
      uncompleted_instances.each do |instance|
        next unless instance.required_predecessors_completed?

        instance.run

        instance.activity.successors.each do |successor|
          successor_instance = find_or_create_activity_instance(successor)
          successor_instance.completed_predecessors << instance
          Workflow::FileHelper.link_instance_output_to_successor_input(instance, successor_instance)
        end

        if instance.activity.type == 'end'
          @queue.clear
          Workflow::FileHelper.link_instance_output_to_workflow_output(instance)
        end
      end
    end

    private

    def uncompleted_instances
      @queue.reject{ |ai| ai.completed? }
    end

    def start_activity
      start_activity = @process_definition.activities.find { |a| a.type == 'start' }
    end

    def queue_activity_instance(instance)
      @queue << instance
      @activity_instances[instance.activity.id] << instance
    end

    def find_or_create_activity_instance(activity)
      @activity_instances[activity.id] ||= []
      instance = @activity_instances[activity.id].find { |ai| !ai.completed? }
      if instance.nil?
        instance = Workflow::ActivityInstance.new(activity)
        Workflow::FileHelper.create_activity_instance_workdir(instance)
        queue_activity_instance(instance)
      end
      instance
    end
  end
end

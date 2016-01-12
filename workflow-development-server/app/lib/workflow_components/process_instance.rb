module Workflow
  class ProcessInstance
    def initialize(start_activity_id:, logger:, process_definition:, config:)
      @config = config
      @logger = logger
      @process_definition = process_definition
      @start_activity_id = start_activity_id
      @activity_instances = {}
      @queue = []
      @meta = { type: "WorkflowInstance", id: @config.main_workflow_id }

      FileUtils.mkdir(workflow_input_dir) unless Dir.exist?(workflow_input_dir)
    end

    def start
      validate_input_data
      @logger.event @meta, { info: 'Input valid' }

      prepare_start_activity

      loop do
        break if @queue.compact.empty?
        process_queued_activities
      end
    end

    def process_queued_activities
      @queue.reject{ |ai| ai.completed? }.each do |activity_instance|
        next unless activity_instance.all_predecessors_completed?

        activity_instance_container = create_activity_container(activity_instance)
        activity_instance.activate do
          activity_instance_container.start
        end
        activity_instance.complete

        activity_instance.activity.successors.each do |successor|
          successor_instance = find_or_create_instance_for_activity(successor)
          successor_instance.completed_predecessors << activity_instance
          link_output_to_successor_input(activity_instance, successor_instance)
        end
        
        if activity_instance.activity.type == 'EndActivity'
          @queue.clear
          link_output_to_workflow_output(activity_instance)
        end 
      end
    end

    def find_or_create_instance_for_activity(activity)
      @activity_instances[activity.id] ||= []
      successor_instance = @activity_instances[activity.id].find { |ai| !ai.completed? }

      if successor_instance.nil?  
        successor_instance = Workflow::ActivityInstance.new(activity)
        prepare_activity_instance_workdir(successor_instance)
        @queue << successor_instance
        @activity_instances[activity.id] << successor_instance
      end

      successor_instance
    end

    def validate_input_data
      validator = Workflow::Validator.new(
        schema: "/workflow/input.schema.json", 
        data: "#{workflow_input_dir}/input.data.json"
      )
      validator.validate
    end

    def prepare_start_activity
      start_activity = @process_definition.activities.find { |a| a.id == @start_activity_id }
      start_activity_instance = Workflow::ActivityInstance.new(start_activity)
      @activity_instances[start_activity.id] = [start_activity_instance]

      prepare_activity_instance_workdir(start_activity_instance)
      link_input_from_workflow(start_activity_instance)
      @queue = [ start_activity_instance ]
    end

    def prepare_activity_instance_workdir(activity_instance)
      FileUtils.mkdir activity_instance_workdir(activity_instance)
      FileUtils.mkdir activity_instance_output_dir(activity_instance)
    end

    def link_input_from_workflow(activity_instance)
      FileUtils.ln_s(
        "#{@config.workdir}/input/", 
        "#{activity_instance_input_dir(activity_instance)}"
      )
    end

    def link_output_to_workflow_output(activity_instance)
      output_dir = activity_instance_output_dir(activity_instance)
      if Dir.exist?(output_dir)
        FileUtils.ln_s(
          "#{output_dir}",
          "#{@config.workdir}/output" 
        )
      else
        FileUtils.mkdir(workflow_output_dir) unless Dir.exist?(workflow_output_dir)
      end
    end

    def link_output_to_successor_input(activity_instance, successor_instance)
      return unless Dir.exist? activity_instance_output_dir(activity_instance)
      successor_predecessors = successor_instance.activity.predecessors
      if successor_predecessors.nil? || successor_predecessors.length < 2
        FileUtils.ln_s(
          activity_instance_output_dir(activity_instance), 
          "#{activity_instance_input_dir(successor_instance)}"
        )
      else
        successor_input_dir = create_activity_instance_input_dir(activity_instance)
        FileUtils.ln_s(
          activity_instance_output_dir(activity_instance), 
          "#{successor_input_dir}/#{activity_instance.id}"
        )
      end
    end

    def create_activity_instance_input_dir(activity_instance)
      input_dir_path = activity_instance_input_dir(activity_instance)
      return input_dir_path if Dir.exist?(input_dir_path)
      FileUtils.mkdir(input_dir_path)
      input_dir_path
    end

    def workflow_input_dir
      "#{@config.workdir}/input"
    end

    def workflow_output_dir
      "#{@config.workdir}/output"
    end

    def activity_instance_workdir(activity_instance)
      "#{@config.workdir}/#{activity_instance.id}"
    end

    def activity_instance_input_dir(activity_instance)
      "#{activity_instance_workdir(activity_instance)}/input"
    end

    def activity_instance_output_dir(activity_instance)
      "#{activity_instance_workdir(activity_instance)}/output"
    end

    def create_activity_container(activity_instance)
      Workflow::Docker::Container.new( 
        name: "ac_#{activity_instance.id}",
        image: "#{@config.image_repository}/ac_#{activity_instance.activity.id}",
        network_name: @config.network,
        volumes_from: [
          "workflowexecutionserver_gem_data_1",
          @config.workflow_relevant_data_container
        ],
        environment_variables: {
          network: @config.network,
          main_workflow_id: @config.main_workflow_id,
          gem_data_container: @config.gem_data_container,
          workdir: activity_instance_workdir(activity_instance),
        }
      )
    end
  end
end

module Workflow
  module FileHelper
    extend self

    def workflow_input_dir
      "#{Workflow::Configuration.workdir}/input"
    end

    def workflow_output_dir
      "#{Workflow::Configuration.workdir}/output"
    end

    def activity_instance_workdir(instance)
      "#{Workflow::Configuration.workdir}/#{instance.id}"
    end

    def activity_instance_input_dir(instance)
      "#{activity_instance_workdir(instance)}/input"
    end

    def activity_instance_output_dir(instance)
      "#{activity_instance_workdir(instance)}/output"
    end

    def create_activity_instance_workdir(instance)
      FileUtils.mkdir activity_instance_workdir(instance)
      FileUtils.mkdir activity_instance_output_dir(instance)
    end

    def ensure_workflow_input_dir
      FileUtils.mkdir_p(workflow_input_dir) unless Dir.exist?(workflow_input_dir)
      if File.exist? Workflow::Configuration.input_data
        FileUtils.copy(Workflow::Configuration.input_data, workflow_input_dir)
      end
    end

    def link_workflow_input_to_start_activity_instance_input(instance)
      FileUtils.ln_s(
        "#{Workflow::Configuration.workdir}/input/",
        "#{activity_instance_input_dir(instance)}"
      )
    end

    def link_instance_output_to_successor_input(instance, successor_instance)
      return unless Dir.exist?(activity_instance_output_dir(instance))
      return if Dir.exist?(activity_instance_input_dir(successor_instance))

      FileUtils.ln_s(activity_instance_output_dir(instance), "#{activity_instance_input_dir(successor_instance)}")

      #successor_predecessors = successor_instance.activity.predecessors
      # if successor_predecessors.nil? || successor_predecessors.length < 2
      #   FileUtils.ln_s(activity_instance_output_dir(instance), "#{activity_instance_input_dir(successor_instance)}")
      # else
      #   successor_input_dir = create_activity_instance_input_dir(instance)
      #   FileUtils.ln_s(activity_instance_output_dir(instance), "#{successor_input_dir}/#{instance.id}")
      # end
    end

    def link_instance_output_to_workflow_output(instance)
      output_dir = activity_instance_output_dir(instance)
      if Dir.exist?(output_dir)
        FileUtils.ln_s(output_dir, workflow_output_dir)
      else
        FileUtils.mkdir(workflow_output_dir) unless Dir.exist?(workflow_output_dir)
      end
    end
  end
end

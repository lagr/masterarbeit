module Activity
  module FileHelper
    extend self

    def workdir
      Activity::Configuration.workdir
    end

    def input_dir
      "#{workdir}/input"
    end

    def output_dir
      "#{workdir}/output"
    end

    def info_data
      "#{Activity::Configuration.confdir}/activity.info.json"
    end

    def input_data
      "#{input_dir}/input.data.json"
    end

    def output_data
      "#{output_dir}/input.data.json"
    end

    def subworkflow_workdir(workflow_instance_id)
      "#{workdir}/#{workflow_instance_id}"
    end

    def create_subworkflow_workdir(workflow_instance_id)
      FileUtils.mkdir subworkflow_workdir(workflow_instance_id)
      subworkflow_workdir(workflow_instance_id)
    end
  end
end

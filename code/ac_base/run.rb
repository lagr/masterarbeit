require 'fileutils'
require 'json'
require 'resolv'

require_relative 'configuration'
require_relative 'file_helper'

module Activity
  class Instance
    def initialize
      @activity_id = Activity::Configuration.activity_id
      @activity_instance_id = Activity::Configuration.activity_instance_id
      @data = JSON.parse File.read(Activity::FileHelper.input_data)
      @activity_info = JSON.parse File.read(Activity::FileHelper.info_data)
      @activity_configuration = @activity_info['configuration']
    end

    def start
      case @activity_info['type']
      when 'manual'       then start_user_input
      when 'container'    then start_container
      when 'subworkflow'  then start_subworkflow
      else log_self_to_data
      end

      write_output
    end

    private

    def start_container
      require_relative 'container_invocation'
      invocation = Activity::ContainerInvocation.new(@activity_configuration)
      invocation.start
      log_result(invocation.result)
    end

    def start_subworkflow
      require_relative 'subworkflow_invocation'
      invocation = Activity::SubworkflowInvocation.new(@activity_info)
      invocation.start
      log_result(invocation.result)
    end

    def start_user_input
      require_relative 'worklist_client'
      worklist_client = Activity::WorklistClient.new(@activity_info)
      worklist_client.request_user_input
      log_result(worklist_client.result)
    end

    def log_self_to_data
      log_result({
        activity: @activity_id,
        activity_instance: @activity_instance_id
      })
    end

    def log_result(result)
      @data[@activity_instance_id] = result
    end

    def write_output
      File.open(Activity::FileHelper.output_data, "w") do |file|
        file.write(@data.to_json)
      end
    end
  end
end


# ensure the container is connected to the networks before starting processing
begin
  Resolv.getaddress "#{Activity::Configuration.container_name}.wfms_enactment"
rescue
  sleep 0.1
  retry
else
  Activity::Instance.new.start
end
exit

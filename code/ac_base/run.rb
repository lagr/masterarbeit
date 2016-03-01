require 'fileutils'
require 'json'
require 'resolv'

require_relative 'configuration'
require_relative 'file_helper'

module Activity
  extend self

  def start
    case activity_info['type']
    when 'manual'       then start_user_input
    when 'container'    then start_container
    when 'subworkflow'  then start_subworkflow
    else log_self_to_input
    end

    write_output
  end

  private

  def start_container
    require 'docker-api'
    config = activity_info['configuration']
    registry = Activity::Configuration.image_registry
    image_tag = "#{config['image']}:#{config['image_version']}"

    container = Docker::Container.create({
      'name' => "#{Activity::Configuration.container_name}_#{config['image']}",
      'Image' => "#{registry}/#{image_tag}",
      'Cmd' => config['cmd'].split(' ')
    })

    container.start
    container.wait(60 * 60)

    input[Activity::Configuration.activity_instance_id] = {
      container_out: container.logs(stdout: true),
      container_err: container.logs(stderr: true)
    }
  end

  def start_user_input
    require_relative 'worklist_item'

    worklist_item = Activity::WorklistItem.new(activity_info['configuration'])
    worklist_item.expose

    input[Activity::Configuration.activity_instance_id] = {
      activity: Activity::Configuration.activity_id,
      manual_form_data: worklist_item.data
    }
  end

  def start_subworkflow
  end

  def log_self_to_input
    input[Activity::Configuration.activity_instance_id] = {
      activity: Activity::Configuration.activity_id
    }
  end

  def write_output
    File.open(Activity::FileHelper.output_data, "w") do |file|
      file.write(input.to_json)
    end
  end

  def activity_info
    @activity_info ||= JSON.parse File.read(Activity::FileHelper.info_data)
  end

  def input
    @input ||= JSON.parse File.read(Activity::FileHelper.input_data)
  end
end


# ensure the container is connected to the networks before starting processing
begin
  Resolv.getaddress "#{Activity::Configuration.container_name}.wfms_enactment"
rescue
  sleep 0.1
  retry
else
  Activity.start
end
exit

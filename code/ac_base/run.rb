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

    container = Docker::Container.create({
      'name' => "aci_#{Activity::Configuration.activity_instance_id}_#{config['image']}",
      'Image' => "#{Activity::Configuration.image_registry}/#{config['image']}:#{config['image_version']}",
      'Cmd' => config['cmd'].split(' ')
    })

    container.start
    container.wait(60 * 60)
    input[Activity::Configuration.activity_instance_id] = { container_logs: container.logs(stdout: true) }
  end

  def start_user_input
    # config = activity_info['configuration']
    # unser_input_container = config['user_input_container']
    # unless Docker::Container.exist?('user-interface')
    # end

    # ui ||= Docker::Container.get('user-interface')
    # request_input_form
    # loop do
    #   query_form_data_present?
    #   get_form_data
    # end
    # request_form_deletion
    input[Activity::Configuration.activity_instance_id] = { activity: Activity::Configuration.activity_id, manual_form_data: {name: "Peter Müllerd"} }
  end

  def start_subworkflow
  end

  def log_self_to_input
    input[Activity::Configuration.activity_instance_id] = { activity: Activity::Configuration.activity_id }
  end

  def write_output
    File.open("#{ENV['WORKDIR']}/output/input.data.json", "w") { |f| f.write(input.to_json) }
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
  Resolv.getaddress "aci_#{Activity::Configuration.activity_instance_id}.wfms_enactment"
rescue
  sleep 0.1
  retry
else
  Activity.start
end
exit

require 'rubygems'
require 'json'
require 'resolv'
require 'fileutils'
require 'docker-api'

require_relative 'configuration'
require_relative 'file_helper'
require_relative 'validator'
require_relative 'process_definition'
require_relative 'process_instance'
require_relative 'activity_instance'

module Workflow
  extend self

  def start
    container = Workflow::Configuration.workflow_instance_container
    instance_network = Docker::Network.create(Workflow::Configuration.network)
    begin
      process_instance = Workflow::ProcessInstance.new
      instance_network.connect(container)
      process_instance.start
      instance_network.disconnect(container)
      instance_network.remove
    rescue
      instance_network.remove
    end
  end
end


#ensure the container is connected to the required networks before starting processing
retries = 20
begin
  Resolv.getaddress("wfms_engine_1.wfms_enactment")
rescue
  sleep 0.1
  retries -= 1
  retry if retries > 0
  abort "no connection"
else
  Workflow.start
end

exit

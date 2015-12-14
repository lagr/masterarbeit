require 'rubygems'
require 'json'
require 'fileutils'
require 'aasm'
require 'excon'

require_relative 'configuration'
require_relative 'logger'
require_relative 'validator'
require_relative 'mapper'
require_relative 'process_definition'
require_relative 'process_instance'
require_relative 'activity_instance'
require_relative 'docker'

module Workflow
  extend self

  def start
    config = Workflow::Configuration
    #Excon.post("#{config.execution_server_api_url}/workflow_management/workflow_instance")

    process_instance = Workflow::ProcessInstance.new(
      start_activity_id: "bdb17d3a-5b0b-42d6-9fbd-8b20355ec3f2",
      config: config,
      logger: Workflow::Logger.new,
      process_definition: Workflow::ProcessDefinition.new(definition_path: "#{config.workdir}/process_definition.json")
    )

    process_instance.start
  end
end

Workflow.start

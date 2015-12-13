require 'rubygems'
require 'docker-api'
require 'json'
require 'fileutils'
require 'aasm'
require 'excon'

require_relative 'logger'
require_relative 'validator'
require_relative 'mapper'
require_relative 'process_definition'
#require_relative 'workflow_instance'

module Workflow
  extend self

  def start
    # process_instance = Workflow::ProcessInstance.new(
    #   start_element: ENV['TRIGGERED_START_ELEMENT'],
    #   workdir: ENV['WORKDIR'],
    #   logger: Workflow::Logger.new(engine_url: ENV['WORKFLOW_ENGINE_URL']),
    #   process_definition: Workflow::ProcessDefinition.new
    # )

    # process_instance.start
    puts Excon.get("http://workflowexecutionserver_web_1.net_#{ENV['WORKFLOW_ID']}:3001/images").body
  end
end

Workflow.start

# puts "reading envs"
# puts workflow_id = ENV['WORKFLOW_ID']
# puts workdir = ENV['WORKDIR']
# ENV.each_pair(&method(:puts))

# %x( docker run \
#   --net=net_#{workflow_id} \
#   --name=activity_in_#{workflow_id} \
#   --rm \
#   -v /woanders \
#   cogniteev/echo \
#   echo '#{workflow_id}'
# )

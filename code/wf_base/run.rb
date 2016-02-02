require 'rubygems'
`gem list -i bundler || gem install bundler`
`bundle check || bundle install`

require 'json'
require 'fileutils'
require 'aasm'
require 'excon'
require 'docker-api'

require_relative 'configuration'
require_relative 'file_helper'
require_relative 'logger'
require_relative 'validator'
require_relative 'mapper'
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
    ensure
      instance_network.disconnect(container)
      instance_network.remove
    end
  end
end

Workflow.start
exit

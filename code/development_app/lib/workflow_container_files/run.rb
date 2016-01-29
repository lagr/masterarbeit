`bundle check || bundle install`

require 'rubygems'
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
    process_instance = Workflow::ProcessInstance.new
    process_instance.start
  end
end

Workflow.start
exit

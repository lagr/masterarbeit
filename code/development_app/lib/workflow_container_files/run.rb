`bundle check || bundle install`

require 'rubygems'
require 'json'
require 'fileutils'
require 'aasm'
require 'excon'
require 'docker'
require 'bunny'

require_relative 'configuration'
require_relative 'file_helper'
require_relative 'logger'
require_relative 'validator'
require_relative 'mapper'
require_relative 'process_definition'
require_relative 'process_instance'
require_relative 'activity_instance'
require_relative 'docker'

connection = Bunny.new
connection.start
at_exit { connection.stop }

channel  = connection.create_channel
# topic exchange name can be any string
exchange = channel.topic("weathr", :auto_delete => true)

module Workflow
  extend self

  def start
    process_instance = Workflow::ProcessInstance.new
    process_instance.start
  end
end

Workflow.start
exit

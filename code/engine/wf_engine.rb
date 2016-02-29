require 'hutch'
require 'docker-api'

Hutch::Config.load_from_file File.expand_path('config.yml')
Hutch.connect

Dir.glob(File.join('./', '{lib,consumers}', '**', '*.rb'), &method(:require))

module WorkflowEngine
  def self.match_message(message)
    /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)
  end
end


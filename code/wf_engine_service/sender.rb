module WorkflowEngine
  module Sender
    Hutch::Config.load_from_file File.expand_path('config.yml')
    Hutch.connect
    extend self

    def publish(routing_key = "", payload = {})
      Hutch.publish routing_key, payload
    end
  end
end

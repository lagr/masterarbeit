require 'hutch'
require 'docker-api'

Hutch::Config.load_from_file File.expand_path('config.yml')
Hutch.connect

require_relative 'docker_helper'
#require_relative 'server_manager'
require_relative 'workflow_instance'

module WorkflowEngine
  def self.match_message(message)
    /wfms\.(\w+)\.(\w+)\.([\w-]+)/.match(message.routing_key).captures.map(&:to_sym)
  end

  class WorkflowConsumer
    include Hutch::Consumer
    consume 'wfms.workflow.#'

    def process(message)
      subject, action, subject_id = WorkflowEngine.match_message(message)
      case action
      when :start
        begin
          wfi = WorkflowEngine::WorkflowInstance.new(message[:id], message[:input_data], 'cloud-machine')
          result = wfi.run
          Hutch.publish "wfms.workflow_instance.finished", workflow_instance: wfi.instance_id, result: result
        rescue Exception => e
          Hutch.publish "wfms.workflow_instance.failed", workflow_instance: wfi.instance_id, exception: e
        end
      end
    end
  end

  class WorkflowInstanceConsumer
    include Hutch::Consumer
    consume 'wfms.workflow_instance.#'

    def process(message)
      subject, action, subject_id = WorkflowEngine.match_message(message)
    end
  end

  # class ServerConsumer < WFMSConsumer
  #   include Hutch::Consumer
  #   consume 'wfms.server.#'

  #   def process(message)
  #     server_manager = WorkflowEngine::ServerManager

  #     case action_of(message)
  #     when 'add'
  #       #server_manager.prepare(server: message[:server])
  #     when 'update'
  #       #server_manager.adapt(server: message[:server])
  #     end
  #   end
  # end
end

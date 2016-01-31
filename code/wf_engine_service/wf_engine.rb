require 'hutch'
require 'docker-api'

require_relative 'sender'
require_relative 'docker_helper'
require_relative 'server_manager'
require_relative 'workflow_scheduler'
require_relative 'workflow_instance'

module WorkflowEngine

  class WFMSConsumer
    def action_of(message)
      message.routing_key.gsub(/wfms\.\w+\./, '')
    end
  end

  class WorkflowConsumer < WFMSConsumer
    include Hutch::Consumer
    consume 'wfms.workflow.#'

    def process(message)
      workflow_scheduler =
      case action_of(message)
      when 'start'
        wfi = WorkflowEngine::WorkflowInstance.new(message[:id], message[:input_data], 'cloud-machine')
        begin
          result = wfi.run
          WorkflowEngine::Sender.publish "wfms.workflow_instance.finished", workflow_instance: wfi.instance_id, result: result
        rescue Exception => e
          WorkflowEngine::Sender.publish "wfms.workflow_instance.failed", workflow_instance: wfi.instance_id, exception: e
        end
      end
    end
  end

  class WorkflowInstanceConsumer < WFMSConsumer
    include Hutch::Consumer
    consume 'wfms.workflow_instance.#'

    def process(message)
      case action_of(message)
      when 'ready'
        #@workflow_scheduler.start(workflow_instance: message[:id])
      end
    end
  end

  class ServerConsumer < WFMSConsumer
    include Hutch::Consumer
    consume 'wfms.server.#'

    def process(message)
      server_manager = WorkflowEngine::ServerManager

      case action_of(message)
      when 'add'
        server_manager.prepare(server: message[:server])
      when 'update'
        server_manager.adapt(server: message[:server])
      end
    end
  end
end

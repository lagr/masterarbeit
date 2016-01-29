require 'hutch'
require 'docker-api'

require_relative 'sender'
require_relative 'docker_helper'
require_relative 'server_manager'
require_relative 'workflow_scheduler'
require_relative 'workflow_instance'

module WorkflowEngine
  @sender = WorkflowEngine::Sender
  @server_manager = WorkflowEngine::ServerManager.new(self)
  @workflow_scheduler = WorkflowEngine::WorkflowScheduler.new(self)

  class WorkflowConsumer
    include Hutch::Consumer
    consume 'wfms.workflow.#'

    def process(message)
      case message.routing_key.remove('wfms.workflow.')
      when 'start'
        @workflow_scheduler.instanciate(workflow: message[:id])
      end
    end
  end

  class WorkflowInstanceConsumer
    include Hutch::Consumer
    consume 'wfms.workflow_instance.#'

    def process(message)
      # case message.routing_key.remove('wfms.workflow_instance.')
      # when 'ready'
      #   @workflow_scheduler.start(workflow_instance: message[:id])
      # end
    end
  end

  class ServerConsumer
    include Hutch::Consumer
    consume 'wfms.server.#'

    def process(message)
      case message.routing_key.remove('wfms.server.')
      when 'add'
        @server_manager.prepare(server: message[:id])
      when 'update'
        @server_manager.adapt(server: message[:server])
      end
    end
  end
end

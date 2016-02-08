require 'hutch'
require 'docker-api'

Hutch::Config.load_from_file File.expand_path('config.yml')
Hutch.connect

require_relative 'docker_helper'
#require_relative 'server_manager'
require_relative 'workflow_instance'

module WorkflowEngine
  def self.match_message(message)
    /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)
  end

  def EngineConsumer
    include Hutch::Consumer
    consume 'wfms.*.output.*',
            'wfms.*.input.*',
            'wfms.*.failed',
            'wfms.workflow.#'

    def process(message)
      subject, action, status = WorkflowEngine.match_message(message)

      case subject
      when :workflow
        if action == :start
          Hutch.publish
        end
      when :workflow_instance
      when :activity_instance
      end
    end
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

  class ServerConsumer
    include Hutch::Consumer
    consume 'wfms.server.#'

    def process(message)
      subject, action, subject_id = WorkflowEngine.match_message(message)
      server = message[:server]

      case action
      when :add
          provisioner = Docker::Container.create({
            'name' => "provisioner-#{server[:name]}",
            'Image' => "provisioner",
            'Cmd' => [''],
            'HostConfig' => {'Binds' => ['/var/run/docker.sock:/var/run/docker.sock']},
            'Env' => ["constraint:node==#{server[:name]}"],
            'AttachStdin' => false, 'AttachStdout' => false, 'AttachStderr' => false,
            'Tty' => true
          })

          Docker::Network.get('wfms_enactment').connect("provisioner-#{server[:name]}")
          provisioner.start
      when 'update'
        #server_manager.adapt(server: message[:server])
      end
    end
  end
end

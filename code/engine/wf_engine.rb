require 'hutch'
require 'docker-api'

Hutch::Config.load_from_file File.expand_path('config.yml')
Hutch.connect

require_relative 'docker_helper'
#require_relative 'server_manager'
require_relative 'workflow_instance'

class WFMS
  class EngineConsumer
    include Hutch::Consumer
    consume 'wfms.activity_instance.#',
            'wfms.workflow_instance.#',
            'wfms.workflow.#'

    def match_message(message)
      /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)
    end

    def process(message)
      subject, action, status = match_message(message)

      case subject
      when :workflow
        WFMS::Engine.instanciate(message[:id], message[:input_data]) if action == :start
      when :workflow_instance
      when :activity_instance
      end
    end
  end

  module Engine
    @workflow_instances = {}

    def instanciate(workflow_id)
      target_node = 'cloud-machine'
      instance = WorkflowInstance.new(workflow_id, target_node)
      @workflow_instances[instance.id] = instance
    end

    def pause(workflow_instance_id)
      workflow_instance_containers(workflow_instance_id).map(&:pause)
    end

    def unpause(workflow_instance_id)
      workflow_instance_containers(workflow_instance_id).map(&:unpause)
    end

    def terminate(workflow_instance_id)
      workflow_instance_containers(workflow_instance_id).map(&:kill)
      workflow_instance_containers(workflow_instance_id).map(&:delete)
    end

    private

    def workflow_instance_containers(workflow_instance_id)
      filters =  { label: ["wfi_#{workflow_instance_id}"] }.to_json
      Docker::Container.all(all: 1, filters: filters)
    end
  end
end













  # class WorkflowConsumer
  #   include Hutch::Consumer
  #   consume 'wfms.workflow.#'

  #   def process(message)
  #     subject, action, subject_id = WFMS.match_message(message)
  #     case action
  #     when :start
  #       begin
  #         wfi = WFMS::WorkflowInstance.new(message[:id], message[:input_data], 'cloud-machine')
  #         result = wfi.run
  #         Hutch.publish "wfms.workflow_instance.finished", workflow_instance: wfi.instance_id, result: result
  #       rescue Exception => e
  #         Hutch.publish "wfms.workflow_instance.failed", workflow_instance: wfi.instance_id, exception: e
  #       end
  #     end
  #   end
  # end

  # class WorkflowInstanceConsumer
  #   include Hutch::Consumer
  #   consume 'wfms.workflow_instance.#'

  #   def process(message)
  #     subject, action, subject_id = WFMS.match_message(message)
  #   end
  # end

  # class ServerConsumer
  #   include Hutch::Consumer
  #   consume 'wfms.server.#'

  #   def process(message)
  #     subject, action, subject_id = WFMS.match_message(message)
  #     server = message[:server]

  #     case action
  #     when :add
  #         provisioner = Docker::Container.create({
  #           'name' => "provisioner-#{server[:name]}",
  #           'Image' => "provisioner",
  #           'Cmd' => [''],
  #           'HostConfig' => {'Binds' => ['/var/run/docker.sock:/var/run/docker.sock']},
  #           'Env' => ["constraint:node==#{server[:name]}"],
  #           'AttachStdin' => false, 'AttachStdout' => false, 'AttachStderr' => false,
  #           'Tty' => true
  #         })

  #         Docker::Network.get('wfms_enactment').connect("provisioner-#{server[:name]}")
  #         provisioner.start
  #     when 'update'
  #       #server_manager.adapt(server: message[:server])
  #     end
  #   end
  # end

require 'hutch'
require 'docker-api'

Hutch::Config.load_from_file File.expand_path('config.yml')
Hutch.connect

Dir.glob(File.join('./', '{lib,consumers}', '**', '*.rb'), &method(:require))

module WorkflowEngine
  extend self

  def match_message(message)
    /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)
  end

  def instanciate(workflow_id, input_data)
    wfi = WorkflowEngine::WorkflowInstance.new(workflow_id, input_data)
    begin
      result = wfi.start
      Hutch.publish "wfms.workflow_instance.finished", workflow_instance: wfi.instance_id, result: result
    rescue Exception => e
      Hutch.publish "wfms.workflow_instance.failed", workflow_instance: wfi.instance_id, exception: e
    end
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
    filters =  { label: ["main_workflow_instance=wfi_#{workflow_instance_id}"] }.to_json
    Docker::Container.all({all: 1, filters: filters})
  end
end

module WorkflowEngine
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
end

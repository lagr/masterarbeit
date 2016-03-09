module WorkflowEngine
  class WorkflowConsumer
    include Hutch::Consumer
    consume 'wfms.workflow.#'

    def process(message)
      subject, action, subject_id = WorkflowEngine.match_message(message)
      return unless action == :start
      Hutch.publish "wfms.workflow_instance.started", id: message[:id]
      WorkflowEngine.instanciate(message[:id], message[:input_data])
    end
  end
end

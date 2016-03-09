module WorkflowEngine
  class WorkflowInstanceConsumer
    include Hutch::Consumer
    consume 'wfms.workflow_instance.#'

    def process(message)
      subject, action, subject_id = WorkflowEngine.match_message(message)
      return unless [:pause, :unpause, :terminate].include?(action)

      WorkflowEngine.send(action, message[:id])
      Hutch.publish "wfms.workflow_instance.#{action}d", id: message[:id]
    end
  end
end

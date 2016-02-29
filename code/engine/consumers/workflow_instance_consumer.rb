module WorkflowEngine
  class WorkflowInstanceConsumer
    include Hutch::Consumer
    consume 'wfms.workflow_instance.#'

    def process(message)
      subject, action, subject_id = WorkflowEngine.match_message(message)
    end
  end
end

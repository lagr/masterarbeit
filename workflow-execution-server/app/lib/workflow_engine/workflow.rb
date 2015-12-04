module WorkflowEngine
  module Workflow
    def self.instanciate(workflow:, input_data: nil)
      return unless workflow.present? and workflow.valid? and workflow.is_valid_input_data?(input_data)

      if workflow_instance = WorkflowInstance.create(workflow: workflow)
        workflow_instance.process_instance = WorkflowEngine::Process.instanciate(process_definition: workflow.process_definition, input_data: input_data)
        workflow_instance
      else
        raise WorkflowEngine::Errors::WorkflowInstantiationError
      end
    end

    def self.stop(workflow_instance:)
      return unless workflow_instance.present?

      workflow_instance.stop
      if WorkflowEngine::Process.stop(workflow_instance.process_instance)
        return true
      else
        #raise
      end
    end
  end
end

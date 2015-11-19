module WorkflowEngine
  module WorkflowVersion
    def self.instanciate(workflow_version:, input_data: nil)
      return unless workflow_version.present? and workflow_version.valid? and workflow_version.is_valid_input_data?(input_data)

      if workflow_version_instance = WorkflowVersionInstance.create(workflow_version: workflow_version)
        workflow_version_instance.process_instance = WorkflowEngine::Process.instanciate(process_definition: workflow_version.process_definition, input_data: input_data)
        workflow_version_instance
      else
        raise WorkflowEngine::Errors::WorkflowVersionInstantiationError
      end
    end

    def self.stop(workflow_version_instance:)
      return unless workflow_version_instance.present?

      workflow_version_instance.stop
      if WorkflowEngine::Process.stop(workflow_version_instance.process_instance)
        return true
      else
        #raise
      end
    end
  end
end

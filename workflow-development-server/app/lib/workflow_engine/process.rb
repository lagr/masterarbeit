module WorkflowEngine
  module Process
    def self.instanciate(process_definition:, input_data: nil)
      return unless process_definition.present? and process_definition.valid?

      if process_instance = ProcessInstance.create(process_definition: process_definition)
        process_instance.start
        return process_instance
      else
        raise WorkflowEngine::Errors::ProcessInstantiationError
      end
    end

    def self.stop(process_instance:)
      return unless process_instance.present?
      process_instance.stop
      if WorkflowEngine::Activity.stop_all(process_instance.activity_instances)
        return true
      else
        #raise
      end
    end
  end
end

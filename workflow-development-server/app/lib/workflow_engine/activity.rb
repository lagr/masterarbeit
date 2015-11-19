module WorkflowEngine
  module Activity
    def self.instanciate(activity_element:, input_data: nil)
      return unless activity_element.present?

      if activity_instance = ProcessInstance.create(process_definition: process_definition)
        activity_instance.start
        return activity_instance
      else
        raise WorkflowEngine::Errors::ActivityInstantiationError
      end
    end
    def self.stop(activity_instance:)
      return unless activity_instance.present?
      activity_instance.stop
    end
  end
end

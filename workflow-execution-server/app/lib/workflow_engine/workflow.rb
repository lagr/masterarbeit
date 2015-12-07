module WorkflowEngine
  module Workflow
    extend self

    def instanciate(workflow:, input_data: nil)
      return unless workflow.present? and workflow.valid?

      if workflow_instance = WorkflowInstance.create(workflow: workflow)
        prepare_workflow_relevant_data(workflow_instance)
        
        workflow_instance.process_instance = WorkflowEngine::Process.instanciate(
          process_definition: workflow.process_definition, 
          input_data: input_data
        )

        workflow_instance
      else
        raise WorkflowEngine::Errors::WorkflowInstantiationError
      end
    end

    def stop(workflow_instance:)
      return unless workflow_instance.present?

      workflow_instance.stop
      if WorkflowEngine::Process.stop(workflow_instance.process_instance)
        return true
      else
        #raise
      end
    end

    private

    def prepare_workflow_relevant_data(workflow_instance)
      raise WorkflowRelevantDataError unless Dir.exist?('/app/tmp/workflow_relevant_data')
      wfi_dir = "/app/tmp/workflow_relevant_data/#{workflow_instance.id}"
      create_io_dirs_in(wfi_dir)
      add_input_data_to(wfi_dir, input_data)
    end

    def create_io_dirs_in(wfi_dir) 
      %[input output].each { |dir| FileUtils.makedirs "#{wfi_dir}/#{dir}" }
    end

    def add_input_data_to(wfi_dir, input_data)
      File.open("#{wfi_dir}/input/input.data.json", 'w') { |a| a.write(input_data) }
    end
  end
end

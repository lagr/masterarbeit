module WorkflowEngine
  module Activity
    extend self

    def instanciate(activity_element:, input_data: nil)
      return unless activity_element.present?

      if activity_instance = ActivityInstance.create(activity: activity_element)
        activity_instance.start
        return activity_instance
      else
        raise WorkflowEngine::Errors::ActivityInstantiationError
      end
    end
    def stop(activity_instance:)
      return unless activity_instance.present?
      activity_instance.stop
    end
  end

  private
  def prepare_activity_relevant_data(activity_instance)
    ai_dir = "/app/tmp/workflow_relevant_data/#{activity_instance.workflow_instance.id}/#{activity_instance.id}"
    create_io_dirs_in(wfi_dir)
    add_input_data_to(wfi_dir)
  end

  def create_io_dirs_in(wfi_dir) 
    %[input output].each { |dir| FileUtils.makedirs "#{wfi_dir}/#{dir}" }
  end

  def add_input_data_to(wfi_dir, input_data)
    File.open("#{wfi_dir}/input/input.data.json", 'w') { |a| a.write(input_data) }
  end
end

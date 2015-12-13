module WorkflowEngine::Activity
  extend self

  def instanciate(activity_element:, input_data: nil)
    return unless activity_element.present?

    if activity_instance = ActivityInstance.create(activity: activity_element)
      activity_instance.activate do
        activity_instance.container = WorkflowContainerAdapter.new(subject: activity_element)
        activity_instance.container.start
        activity_instance.container.container.wait
        activity_instance.container.container.delete force: true
        byebug
      end
      return activity_instance
    else
      raise WorkflowEngine::Errors::ActivityInstantiationError
    end
  end

  def pause(activity_instance:)
    activity_instance.suspend do
      activity_instance.container.pause
    end
  end

  def stop(activity_instance:)
    activity_instance.stop do
      activity_instance.container.stop
    end
  end

  private

  def prepare_activity_relevant_data(activity_instance)
    create_io_dirs_for(activity_instance)
    add_input_data_for(activity_instance)
  end

  def activity_instance_dir(activity_instance)
    "/app/tmp/workflow_relevant_data/#{activity_instance.workflow_instance.id}/#{activity_instance.id}"
  end

  def create_io_dirs_for(activity_instance) 
    %[input output].each { |dir| FileUtils.makedirs "#{activity_instance_dir(activity_instance)}/#{dir}" }
  end

  def add_input_data_for(activity_instance, input_data)
    File.open("#{activity_instance_dir(activity_instance)}/input/input.data.json", 'w') { |a| a.write(input_data) }
  end
end

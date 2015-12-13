class WorkflowContainerAdapter
  attr_accessor :container, :subject

  def initialize(subject:, container: nil)
    @container = container || create
  end

  def create
    Docker::Container.create(
      image: image_name, 
      'volumesFrom' => workflow_relevant_data_container,
      'name' => SecureRandom.uuid,#subject.id,
      #Cmd: ['ruby /activity/run.rb']
      Cmd: ['ls']
    )
  end

  def start
    puts "Starting #{container.info}"
    container.tap(&:start!).attach { |stream, chunk| puts "#{stream}: #{chunk}" }
  end

  def stop
  end

  def pause
  end

  def resume
  end

  def export
  end

  private

  def workflow_relevant_data_container
    #ENV['WORKFLOW_RELEVANT_DATA_CONTAINER'] || 
    ['workflowexecutionserver_workflow_relevant_data_1']
  end

  def image_name
    "wfms_and_split"
    #WorkflowImageManager.image_name_for subject.type
  end
end

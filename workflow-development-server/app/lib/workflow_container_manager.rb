module WorkflowContainerManager
  CONTAINER_REGISTRY = 'localhost:5000'
  IMAGE_TEMP_FOLDER = 'wf_images'

  def self.register_container
  end

  def self.fetch_workflow_container(workflow_container_name)
    result = %x( docker pull #{CONTAINER_REGISTRY}/#{workflow_container_name} )
    byebug
  end

  def self.link_container
  end

  def self.publish_configuration
  end

  def self.containers
    result = %x( docker ps )
  end

  def self.create_container_image
    temp_folder = find_or_create
    %x ()
  end
end

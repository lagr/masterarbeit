module ImageManager
  extend self

  ACTIVITY_CONTAINER_TEMPLATE_PATH = File.expand_path('app/lib/activity_components')
  WORKFLOW_CONTAINER_TEMPLATE_FILES_PATH = File.expand_path('app/lib/workflow_components')

  def create_activity_image(activity)
    image_name = DockerHelper.image_name(type: :activity, id: activity.id)

    build_config = {
      name: image_name,
      tag: { repo: image_name, tag: :latest, force: true },
      build_environment: {
        files_to_copy: {},
        files_to_write: {
          'input.schema' => {type: 'object', required: ['this'], properties: { this: {type: 'string'} } }.to_json,
          'input.schema' => activity.input_schema.to_json,
          'input.mapping' => "{}"
        }
      }
    }

    ImageBuilder.build_image(build_config)
  end

  def create_workflow_image(workflow)
    image_name = DockerHelper.image_name(type: :workflow, id: workflow.id)

    build_config = {
      name: image_name,
      tag: { repo: image_name, tag: :latest, force: true },
      build_environment: {
        files_to_copy: {
          'WorkflowDockerfile' => 'Dockerfile'
        },
        files_to_write: {
          'process_definition.json' => serialize_process_definition(workflow),
          'input.mapping.json' => '{}',
          'input.schema.json' => { type: 'object', required: ['this'], properties: { this: { type: 'string' } } }.to_json,
        }
      }
    }

    ImageBuilder.build_image(build_config)
  end

  def publish_image(image, image_name)
    image.tag { repo: "#{DockerHelper.repository_ip}:5000/#{image_name}", tag: :latest, force: true }
    image.push
  end

  private

  def serialize_process_definition(workflow)
    ActiveModel::SerializableResource.new(workflow.process_definition, serializer: ProcessDefinitionImageSerializer, include: '**').serializable_hash.to_json
  end
end

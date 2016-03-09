require 'fileutils'

module ImageBuilder
  extend self

  def build_images(subjects)
    built_images = { successful: [], failed: [] }

    subjects.each do |subject|
      begin
        image = build_image(subject)
        built_images[:successful] << { image: image, subject: subject }
      rescue Exception => e
        built_images[:failed] << { image: image, exception: e }
      end
    end

    built_images
  end

  def build_image(subject)
    case subject
    when Workflow
      build_image_from_config(workflow_build_config(subject))
    when Activity
      build_image_from_config(activity_build_config(subject))
    end
  end

  private

  def build_image_from_config(build_config)
    image = nil
    type = build_config[:type]
    base_name  = ImageManager.image_name(type: type)
    base_image = Docker::Image.get(base_name)

    Dir.mktmpdir do |tmpdir|
      prepare_build_enviroment(tmpdir, build_config[:build_environment])
      image = base_image.insert_local(
        'localPath' => Dir.glob("#{tmpdir}/*"),
        'outputPath' => "/#{build_config[:type]}/",
        'rm' => true)
      image.tag(repo: build_config[:name], tag: :latest, force: true)
    end

    image
  end

  def prepare_build_enviroment(tmpdir, config)
    config[:files_to_write].each_pair { |path, content| File.open("#{tmpdir}/#{path}", 'w') { |a| a.write(content) } }
    config[:files_to_copy].each_pair  { |source, target| FileUtils.copy(source, "#{tmpdir}/#{target}") }
  end

  def serialize_process_definition(workflow)
    ActiveModel::SerializableResource.new(workflow.process_definition, serializer: ProcessDefinitionImageSerializer, include: '**').serializable_hash.to_json
  end

  def activity_build_config(activity)
    image_name = ImageManager.image_name(type: :activity, id: activity.id)
    {
      type: :activity,
      name: image_name,
      tag: { repo: image_name, tag: :latest, force: true },
      build_environment: {
        files_to_copy: {},
        files_to_write: {
          'input.schema.json' => {type: 'object', required: ['this'], properties: { this: {type: 'string'} } }.to_json,
          'activity.info.json' => {
            image_name: image_name,
            type: activity.activity_type,
            subworkflow_id: activity.subworkflow_id,
            participant_role_id: activity.participant_role_id,
            configuration: activity.activity_configuration }.to_json
        }
      }
    }
  end

  def workflow_build_config(workflow)
    image_name = ImageManager.image_name(type: :workflow, id: workflow.id)
    {
      type: :workflow,
      name: image_name,
      tag: { repo: image_name, tag: :latest, force: true },
      build_environment: {
        files_to_copy: {},
        files_to_write: {
          'process_definition.json' => serialize_process_definition(workflow),
          'input.schema.json' => { type: 'object', required: ['this'], properties: { this: { type: 'string' } } }.to_json,
          'workflow.info.json' => { image_name: image_name }.to_json
        }
      }
    }
  end
end

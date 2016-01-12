require 'fileutils'

module ImageManager
  extend self
  CONTAINER_TEMPLATE_FILES_PATH = File.expand_path('app/lib/activity_components')
  WORKFLOW_CONTAINER_TEMPLATE_FILES_PATH = File.expand_path('app/lib/workflow_components')
  WORKFLOW_CONTAINER_TEMPLATE_FILES = %w[mapper.rb run.rb validator.rb activity_instance.rb process_definition.rb process_instance.rb Dockerfile]
  CONTAINER_TEMPLATE_FILES = %w[map.rb run.rb validate.rb Dockerfile]

  ELEMENT_TYPE_TO_IMAGE_NAME = {
    'StartActivity' => 'start',
    'EndActivity' => 'end',
    'OrSplitActivity' => 'or_split',
    'OrJoinActivity' => 'or_join',
    'AndSplitActivity' => 'and_split',
    'AndJoinActivity' => 'and_join',
    'ManualActivity' => 'manual',
    'AutomaticActivity' => 'automatic',
    'ContainerActivity' => 'container',
    'ContainerizedActivity' => 'containerized',
    'SubWorkflowActivity' => 'subworkflow'
  }.with_indifferent_access.freeze

  def create_workflow_base_image
    image = nil
    Dir.mktmpdir do |tmpdir|
      FileUtils.cd WORKFLOW_CONTAINER_TEMPLATE_FILES_PATH do
        FileUtils.copy(Dir.glob('*.rb'), tmpdir)
        FileUtils.copy("BaseDockerfile", "#{tmpdir}/Dockerfile")
        image = Docker::Image.build_from_dir(tmpdir)
        image.tag repo: "wfms_workflow", tag: :latest, force: true
        image.tag repo: "localhost:5000/wfms_workflow", tag: :latest, force: true
        image.push
      end
    end
    return image
  end

  def create_workflow_image(workflow)
    images = { successful: {}, failed: [] }
    serialized_meta_files = {
      'process_definition' => serialize_process_definition(workflow),
      'input.schema' => {type: 'object', required: ['this'], properties: { this: {type: 'string'} } }.to_json,
      'input.mapping' => "{}"
    }
    begin
      Dir.mktmpdir do |tmpdir|
        FileUtils.cd WORKFLOW_CONTAINER_TEMPLATE_FILES_PATH do
          FileUtils.copy("WorkflowDockerfile", "#{tmpdir}/Dockerfile")
          serialized_meta_files.each_pair { |name, content| File.open("#{tmpdir}/#{name}.json", 'w') { |a| a.write(content) } }
          image = Docker::Image.build_from_dir(tmpdir)
          image.tag repo: "localhost:5000/wf_#{workflow.id}", tag: :latest, force: true
          image.push
          images[:successful][workflow.id] = image.id
        end
      end
    rescue
      images[:failed] << workflow
    end
    return images
  end

  def create_activity_images(activities)
    images = { successful: {}, failed: [] }
    activities.each do |activity|
      begin 
        image = create_activity_image(activity: activity)
        images[:successful][activity.id] = image.try(:id) || image[:id]
      rescue Exception => e
        puts e
        images[:failed] << activity 
      end
    end
    images
  end

  def image_name_for(type: nil, types: [])
    types = [type] if types.empty?
    types.collect { |t| "wfms_#{ELEMENT_TYPE_TO_IMAGE_NAME[t]}" }
  end

  def create_activity_base_image(image_name:, options: {})
    return unless valid_image_name?(image_name) && !image_exists?(image_name)
    image = nil

    Dir.mktmpdir do |tmpdir|
      FileUtils.cd CONTAINER_TEMPLATE_FILES_PATH do
        FileUtils.copy("BaseDockerfile", "#{tmpdir}/Dockerfile")
        FileUtils.copy(Dir.glob('*.rb'), tmpdir)
        case
        when options[:activity_file].present?
          FileUtils.copy(options[:activity_file], tmpdir)
        when options[:activity_content].present?
          File.open("#{tmpdir}/activity.rb", 'w') { |a| a.write options[:activity_content] }
        else
          raise ArgumentError, 'Either activity file or contents must be given'
        end
        image = Docker::Image.build_from_dir(tmpdir)
        image.tag repo: image_name, tag: :latest, force: true
        image.push
      end
    end
    return image
  end

  def create_activity_image(activity:, options: {})
    image_name = "#{image_registry}/ac_#{activity.activity_id}"
    base_image_name = image_name_for(type: activity.activity_type).first
    return unless valid_image_name?(image_name)
    return { id: Docker::Image.get(image_name).id[0...12] } if Docker::Image.exist?(image_name)

    image = nil
    serialized_meta_files = {
      'input.schema' => {type: 'object', required: ['this'], properties: { this: {type: 'string'} } }.to_json,
      #'input.schema' => activity.input_schema.to_json,
      'input.mapping' => "{}"#activity.input_mapping
    }

    Dir.mktmpdir do |tmpdir|
      FileUtils.cd CONTAINER_TEMPLATE_FILES_PATH do
        #FileUtils.copy("ActivityDockerfile", "#{tmpdir}/Dockerfile")
        File.open("#{tmpdir}/Dockerfile", 'w') do |d|
          d.puts "FROM #{image_registry}/#{base_image_name}"
          d.puts "COPY . /activity"
        end
        serialized_meta_files.each_pair { |name, content| File.open("#{tmpdir}/#{name}.json", 'w') { |a| a.write(content) } }
        image = build_image(tmpdir, image_name)
      end
    end
    return image
  end

  def create_activity_types_images
    images = { successful: {}, failed: [] }

    #%w[StartActivity EndActivity OrSplitActivity OrJoinActivity AndSplitActivity AndJoinActivity AutomaticActivity ContainerizedActivity]
    %w[StartActivity EndActivity AndSplitActivity AndJoinActivity OrJoinActivity AndJoinActivity ContainerActivity ManualActivity SubWorkflowActivity].each do |activity|
      begin 
        image = create_activity_base_image(
          image_name: "#{image_registry}/#{image_name_for(type: activity).first}",
          options: { activity_file: activity_file_path_for(activity) }
        )
        images[:successful][activity.to_sym] = image.id
      rescue Exception => e
        puts e
        images[:failed] << activity 
      end
    end

    images
  end

  private

  def build_image(dir, image_name)
    image = Docker::Image.build_from_dir(dir)
    image.tag repo: image_name, tag: :latest, force: true
    image.push
    image
  end

  def activity_file_path_for(activity)
    "#{CONTAINER_TEMPLATE_FILES_PATH}/#{ELEMENT_TYPE_TO_IMAGE_NAME[activity]}/activity.rb"
  end

  def image_exists?(image_name)
    false #Docker::Image.exist?(image_name)
  end

  def valid_image_name?(image_name)
    !image_name.blank?
  end

  def image_registry
    'localhost:5000'#Configuration.current.settings['registry'] || 'localhost:5000'
  end

  def serialize_process_definition(workflow)
    ActiveModel::SerializableResource.new(workflow.process_definition, serializer: ProcessDefinitionImageSerializer, include: '**').serializable_hash.to_json
  end
end

require 'fileutils'

module WorkflowImageManager
  extend self
  CONTAINER_TEMPLATE_FILES_PATH = File.expand_path('app/lib/activity_components')
  CONTAINER_TEMPLATE_FILES = %w[map.rb run.rb validate.rb Dockerfile]

  ELEMENT_TYPE_TO_IMAGE_NAME = {
    'StartElement' => 'start',
    'EndElement' => 'end',
    'OrSplitElement' => 'or_split',
    'OrJoinElement' => 'or_join',
    'AndSplitElement' => 'and_split',
    'AndJoinElement' => 'and_join',
    'ManualActivity' => 'manual',
    'AutomaticActivity' => 'automatic',
    'ContainerizedActivity' => 'containerized'
  }.with_indifferent_access.freeze

  def create_process_element_images
    images = { successful: {}, failed: [] }

    %w[StartElement EndElement OrSplitElement OrJoinElement AndSplitElement AndJoinElement AutomaticActivity ContainerizedActivity]
    .each do |activity|
      begin 
        byebug
        image = create_activity_image(
          image_name: "#{image_registry}/#{image_name_for(type: activity).first}",
          options: { activity_file: activity_file_path_for(activity) }
        )
        images[:successful][activity.to_sym] = image.id
      rescue Exception => e
        images[:failed] << activity 
      end
    end

    images
  end

  def image_name_for(type: nil, types: [])
    types = [type] if types.empty?
    types.collect { |t| "wfms_#{ELEMENT_TYPE_TO_IMAGE_NAME[t]}" }
  end

  def create_activity_image(image_name:, options: {})
    return unless valid_image_name?(image_name) && !image_exists?(image_name)
    image = nil

    Dir.mktmpdir do |tmpdir|
      FileUtils.cd CONTAINER_TEMPLATE_FILES_PATH do
        FileUtils.copy CONTAINER_TEMPLATE_FILES, tmpdir
        case
        when options[:activity_file].present?
          FileUtils.copy(options[:activity_file], tmpdir)
        when options[:activity_content].present?
          File.open("#{tmpdir}/activity.rb", 'w') { |a| a.write options[:activity_content] }
        else
          raise ArgumentError, 'Either activity file or contents must be given'
        end

        puts "Building #{image_name}..."
        image = Docker::Image.build_from_dir(tmpdir)
        image.tag repo: image_name, tag: :latest, force: true
        image.push
      end
    end
    return image
  end

  private

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
    Configuration.current.settings['registry'] || 'localhost:5000'
  end
end

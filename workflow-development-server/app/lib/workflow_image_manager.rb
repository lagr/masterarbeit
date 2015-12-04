require 'fileutils'

module WorkflowImageManager
  extend self
  IMAGE_REGISTRY = '0.0.0.0:5000'
  CONTAINER_TEMPLATE_FILES_PATH = File.expand_path('app/lib/activity_components')
  CONTAINER_TEMPLATE_FILES = %w[map.rb run.rb validate.rb Dockerfile]

  def register_container
  end

  def fetch_workflow_container(workflow_container_name)
    result = %x( docker pull #{IMAGE_REGISTRY}/#{workflow_container_name} )
    byebug
  end

  def link_container
  end

  def publish_configuration
  end

  def containers
    result = %x( docker ps )
  end

  def create_container_image
    temp_folder = find_or_create
    %x ()
  end

  def create_control_flow_activity_images
    images = { successful: {}, failed: []}

    %w[and_split and_join].each do |activity|
      begin 
        image = create_activity_image(
          image_name: "#{IMAGE_REGISTRY}/cf_#{activity}",
          options: { activity_file: activity_file_path_for(activity) }
        )
        images[:successful][activity.to_sym] = image.id
      rescue
        images[:failed] << activity 
      end
    end

    images
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
        byebug

        #build_result = %x( docker build -t '#{image_name}:latest' #{tmpdir} )
        puts "Building #{image_name}..."
        image = Docker::Image.build_from_dir(tmpdir)
        image.tag repo: image_name, tag: :latest, force: true
        image.push
      end
    end
    return image
  end
  # if image does not exist
    # copy files in temporary directory
    # build image
    # push image to repository
    # store existence of said containers

  private

  def activity_file_path_for(activity)
    "#{CONTAINER_TEMPLATE_FILES_PATH}/#{activity}/activity.rb"
  end

  def image_exists?(image_name)
    false #TODO
  end

  def valid_image_name?(image_name)
    !image_name.blank?
  end
end

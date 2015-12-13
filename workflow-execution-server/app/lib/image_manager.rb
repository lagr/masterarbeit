module ImageManager
  extend self

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

  def run_workflow
    wf_id = SecureRandom.uuid
    return unless gem_container_exists?
    create_network(wf_id)
    join_network(wf_id)
    #make_gem_container_available(wf_id)
    begin
      response = run_data_container(wf_id)
      response = run_workflow_container(wf_id)
    ensure
      leave_network(wf_id)
      remove_network(wf_id)
    end
  end

  def gem_container_exists?
    true
  end

  def create_network(workflow_id)
    %x( docker network create net_#{workflow_id} )
  end

  def join_network(workflow_id)
    %x( docker network connect net_#{workflow_id} #{ENV['HOSTNAME']})
  end

  def leave_network(workflow_id)
    %x( docker network disconnect net_#{workflow_id} #{ENV['HOSTNAME']})
  end

  def make_gem_container_available(workflow_id)
    %x( docker network create net_#{workflow_id} )
  end

  def remove_network(workflow_id)
    %x( docker network rm net_#{workflow_id} )
  end

  def run_data_container(workflow_id)
    %x( docker run \
      --net=net_#{workflow_id} \
      --name=data_#{workflow_id} \
      -v /app/tmp/workflow_relevant_data \
      cogniteev/echo \
      echo 'Data Container for #{workflow_id}'
    )
  end

  def run_workflow_container(workflow_id)
    command = [ 
      "docker run",
      container("wf_#{workflow_id}"),
      network("net_#{workflow_id}"),
      volumes_from("data_#{workflow_id}"),
      volumes_from("workflowexecutionserver_gem_data_1"),
      workdir("/workflow"),
      environment_variable("WORKFLOW_ID", workflow_id),
      environment_variable("WORKDIR", "/app/tmp/workflow_relevant_data"),
      environment_variable("WORKFLOW_ENGINE_CONTAINER", ENV['HOSTNAME']),
      "-v /var/run/docker.sock:/var/run/docker.sock",
      image("wfms_workflow"),
      file_to_run("run.rb")
    ].join(' ')

    puts "starting #{workflow_id}"

    result = %x(#{command})
    byebug
  end

  def environment_variable(name, value)
    "-e #{name}=#{value}"
  end

  def file_to_run(filename)
    "ruby ./#{filename}"
  end

  def workdir(workdir_path)
    "-w #{workdir_path}"
  end

  def image(image_name)
    image_name
  end

  def container(container_name)
    return if container_name.blank?
    "--name #{container_name}"
  end

  def network(network_name)
    return if network_name.blank?
    "--net=#{network_name}"
  end

  def volumes_from(container_name)
    return "" if container_name.blank?
    "--volumes-from #{container_name}"
  end

  def install_control_flow_activity_images
    images = { successful: [], failed: [] }

    %w[and_split and_join or_split or_join start end].each do |activity|
      begin
        image = install_image("wfms_#{activity}")
        image.tag(repo: "wfms_#{activity}", force: true)
        images[:successful][activity.to_sym] = image.id
      rescue
        images[:failed] << activity 
      end
    end

    images
  end

  def install_images_by_identifiers(identifiers = [])
    images = { successful: [], failed: [] }

    identifiers.each do |identifier|
      begin 
        image = install_image(identifier)
        images[:successful][activity.to_sym] = image.id
      rescue Exception => e
        images[:failed] << activity 
      end
    end

    images
  end

  def install_image(identifier)
    return unless registry.present?
    unless Docker::Image.exist? identifier
      Docker::Image.create(fromImage: "#{registry}/#{identifier}")
      Docker::Image.get("#{registry}/#{identifier}")
    end
  end

  def registry
    Configuration.current.settings['registry']
  end

  def image_name_for(type)
    "wfms_#{ELEMENT_TYPE_TO_IMAGE_NAME[type]}"
  end
end

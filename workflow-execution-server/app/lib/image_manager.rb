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

  def run_workflow(workflow_id=nil)
    wf_id = workflow_id || "aa350fb7-77f0-420f-a30e-4200e5370549"
    wf_instance_id = SecureRandom.uuid
    create_network(wf_instance_id)
    join_network(wf_instance_id)
    begin
      run_data_container(wf_instance_id)
      copy_input_data_to_data_container(wf_instance_id)
      run_workflow_container(wf_instance_id, wf_id)
    ensure
      leave_network(wf_instance_id)
      remove_network(wf_instance_id)
    end
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
    command = [
      "docker run",
      container("data_#{workflow_id}"),
      network("net_#{workflow_id}"),
      volume("/workflow_relevant_data"),
      image('cogniteev/echo'),
      "echo 'Data Container for #{workflow_id}'"
    ].join(' ')

    %x(#{command})
  end

  def run_workflow_container(workflow_instance_id, workflow_id)
    command = [ 
      "docker run",
      container("wf_#{workflow_instance_id}"),
      network("net_#{workflow_instance_id}"),
      volumes_from("data_#{workflow_instance_id}"),
      volumes_from("workflowexecutionserver_gem_data_1"),
      workdir("/workflow"),
      environment_variable("MAIN_WORKFLOW_ID", workflow_instance_id),
      environment_variable("WORKFLOW_ID", workflow_instance_id),
      environment_variable("WORKDIR", "/workflow_relevant_data"),
      environment_variable("NETWORK", "net_#{workflow_instance_id}"),
      environment_variable("DATA_CONTAINER", "data_#{workflow_instance_id}"),
      environment_variable("GEM_DATA_CONTAINER", "workflowexecutionserver_gem_data_1"),
      environment_variable("WORKFLOW_ENGINE_CONTAINER", ENV['HOSTNAME']),
      environment_variable("TRIGGERED_ACTIVITY", "bdb17d3a-5b0b-42d6-9fbd-8b20355ec3f2"),
      volume("/var/run/docker.sock", "/var/run/docker.sock"),
      image("localhost:5000/wf_#{workflow_id}"),
      #image("wfms_workflow"),
      file_to_run("run.rb")
    ].join(' ')

    puts "starting #{workflow_id}"

    result = %x(#{command})
  end

  def copy_input_data_to_data_container(workflow_id)
    Dir.mktmpdir do |tmpdir|
      FileUtils.mkdir "#{tmpdir}/input"
      File.open("#{tmpdir}/input/input.data.json", 'w') { |i| i.write ({this: "is test data"}).to_json }
      %x(docker cp #{tmpdir}/input/ data_#{workflow_id}:/workflow_relevant_data/input/)
    end
  end

  def copy_to_container(container_name, destination, data)
    %x(docker cp - #{container_name}:#{destination})
  end

  def volume(container_dir, host_dir = nil)
    host_dir.present? ? "-v #{host_dir}:#{container_dir}" : "-v #{container_dir}"
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

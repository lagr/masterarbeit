class ExecutionServerConnector
  Net::Ping::TCP.service_check = true       # interpret actively refused connection as signal for running server

  def initialize(server)
    @server = server
    @connection = Excon.new("http://#{server.ip}:#{server.execution_environment_port}/api/v1")
  end

  ## Workflow management
  def deploy(workflows)
    return if workflows.empty?

    serializable = ActiveModel::SerializableResource.new(workflows, serializer: ActiveModel::Serializer::CollectionSerializer, each_serializer: WorkflowDeploymentSerializer)

    response = @connection.post( 
      path: api_path("/workflow_management/workflows/"), 
      :body => URI.encode_www_form(workflows: serializable.to_json),
      headers: { "Content-Type" => "application/x-www-form-urlencoded" })
    response.status.to_s.first == "2"
  end

  def installed_workflows
    api_get '/workflow_management/workflows'
  end

  def workflow_instances
    api_get '/workflow_management/workflow_instances'
  end

  def start_instance(workflow)
    response = @connection.post( 
      path: api_path('/workflow_management/workflow_instances'),
      body: URI.encode_www_form(workflow_instance: { workflow: workflow.id }),
      headers: { "Content-Type" => "application/x-www-form-urlencoded" })
    response.body
  end

  ## Docker 
  def running_containers
    api_get '/docker/containers'
  end

  def installed_images
    response = api_get('/docker/installed_images')
    JSON.parse(response.body) if response.status == 200
  end

  ## Systems status
  def ping?
    Net::Ping::TCP.new(@server.ip).ping?
  end

  def reachable?
    ping?
  end

  def execution_environment_available?
    begin
      @connection.get(path: '/status').status == 200
    rescue
      false
    end
  end

  def docker_available?
    return false unless reachable?
    begin
      response = api_get '/docker/status'
      docker_status = JSON.parse(response.body)['available'] if response.status == 200
      return docker_status
    rescue 
      return false
    end
  end

  private

  def api_path(path)
    "/api/v1#{path}"
  end

  def api_get(path, query={})
    @connection.get path: api_path(path)
  end
end

class RegistryServerConnector
  def initialize(server)
    @server = server
    @connection = Excon.new("http://#{server.ip}:#{server.execution_environment_port}/api/v1")
  end
end

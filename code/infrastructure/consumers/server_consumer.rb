class ServerConsumer
  include Hutch::Consumer
  consume 'wfms.server.#'

  def process(message)
    subject, action, subject_id = /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)
    case action

    when :index
      servers = EnvironmentManager.all_servers
      Hutch.publish "wfms.server.indexed", servers: servers.as_json

    when :show
      server = EnvironmentManager.all_servers.detect {|s| s.name == message[:name] }
      server.containers = EnvironmentManager.containers(server)
      server.images = EnvironmentManager.images(server)
      Hutch.publish "wfms.server.showed", server: server.as_json
    end
  end
end

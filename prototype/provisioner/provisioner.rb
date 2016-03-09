require 'docker-api'

cert_path = "#{ENV['SWARM_MANAGER_CERT_PATH']}"
swarm_manager_url = URI.parse('tcp://' + ENV['SWARM_MANAGER_IP'])
swarm_manager_url.port = 3376

Docker.url = swarm_manager_url.to_s
Docker.options = {
  client_cert: File.join(cert_path, 'cert.pem'),
  client_key: File.join(cert_path, 'key.pem'),
  ssl_ca_file: File.join(cert_path, 'ca.pem'),
  scheme: 'https'
}

def local_connection
  @conn ||= Docker::Connection.new "unix:///var/run/docker.sock", {}
end

begin
  Docker::Event.stream do |event|
    if event.status == 'push' && !event.id.match(/sha\:/)
      puts "pulling #{event.id}"
      Docker::Image.create({fromImage: event.id}, local_connection)
    end
  end
rescue Exception => e
  puts e
  retry
end

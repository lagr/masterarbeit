Docker.url = "unix:///var/run/docker.sock"
Docker.options[:read_timeout] = 1200
Docker.creds = {
  serveraddress: '192.168.99.100:5000'
}

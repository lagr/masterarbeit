Docker.url = "#{ENV['SWARM_MANAGER_URL']}"

cert_path = "#{ENV['SWARM_MANAGER_CERT_PATH']}"

Docker.options = {
    client_cert: File.join(cert_path, 'cert.pem'),
    client_key: File.join(cert_path, 'key.pem'),
    ssl_ca_file: File.join(cert_path, 'ca.pem'),
    scheme: 'https'
}

Docker.options[:read_timeout] = 1200
Docker.creds = {
  serveraddress: '192.168.99.100:5000'
}

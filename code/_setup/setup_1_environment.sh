#!/bin/sh

# This script should setup the docker machines for the example scenario
# Precondition: Docker, Docker-Compose, Docker Machine and VirtualBox are installed
step(){
	echo "\n\n$@"
}

step "Create machine on which the discovery service and the registry will run..."
docker-machine create -d=virtualbox 					  	\
	--swarm 												\
	--swarm-discovery="consul://127.0.0.1:8500"	  			\
    --engine-opt="cluster-store=consul://127.0.0.1:8500"  	\
    --engine-opt="cluster-advertise=eth1:2376"            	\
    --virtualbox-memory "2048" 								\
    coordination-machine

coordination_machine_ip=$(docker-machine ip coordination-machine)
consul_url="consul://$coordination_machine_ip:8500"
registry_url=$(docker-machine ip coordination-machine):5000

step "Load consul image from file and start..."
eval "$(docker-machine env coordination-machine)"
#docker load -i ./images/consul.tar
docker-compose -p consul -f ../consul.yml up -d

step "Create machine on which the swarm master and the development services will run..."
docker-machine create -d virtualbox                        \
	--swarm --swarm-master                                 \
	--swarm-discovery="$consul_url"                        \
	--engine-opt="cluster-store=$consul_url"               \
	--engine-opt="cluster-advertise=eth1:2376"             \
	--engine-label edu.proto.machine_env="internal"        \
	--engine-label edu.proto.ram="500"          	       \
	--engine-insecure-registry $registry_url               \
	--engine-insecure-registry registry_service_1:5000     \
	development-machine

step "Create machine on which the internal enactment will run..."
docker-machine create -d virtualbox                        \
	--swarm                                                \
	--swarm-discovery="$consul_url"                        \
	--engine-opt="cluster-store=$consul_url"               \
	--engine-opt="cluster-advertise=eth1:2376"             \
	--engine-label edu.proto.machine_env="internal"        \
	--engine-label edu.proto.ram="500"          	       \
	--engine-insecure-registry $registry_url               \
	internal-machine

step "Create machine on which the external enactment for wfs with space needs will run..."
docker-machine create -d virtualbox                        \
	--swarm                                                \
	--swarm-discovery="$consul_url"                        \
	--engine-opt="cluster-store=$consul_url"               \
	--engine-opt="cluster-advertise=eth1:2376"             \
	--engine-label edu.proto.machine_env="external"        \
	--engine-label edu.proto.ram="1024"                    \
	--engine-insecure-registry $registry_url               \
	cloud-machine

# step "Preload required images..."
# eval "$(docker-machine env coordination-machine)"
# step "Load registry image from file..."
# docker load -i ./images/registry.tar

# step "Load registry image from file..."
# eval "$(docker-machine env internal-machine)"
# docker load -i ./images/rabbitmq.tar

# step "Load images required by all servers from file..."
# eval "$(docker-machine env --swarm development-machine)"
# docker load -i ./images/base_images.tar

step "Swarm master info:"
docker info
step "Created machines with the following IPs:"
docker run --rm swarm list $consul_url

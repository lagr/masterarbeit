#!/bin/sh

# This script should setup the docker machines for the example scenario
# Precondition: Docker, Docker-Compose, Docker Machine and VirtualBox are installed


#=========== Discovery service machine ===========
# Create machine on which the discovery service will run
echo "\n\nCreate machine on which the discovery service will run...\n"
docker-machine create -d=virtualbox consul-machine
eval $(docker-machine env consul-machine)
docker-compose -f ./consul/docker-compose.yml up -d

consul_machine_ip=$(docker-machine ip consul-machine)
consul_machine_url="consul://$consul_machine_ip:8500"
echo "Consul machine ip is $consul_machine_ip"
echo "Consul machine ur is $consul_machine_url"


#=========== Development machine ===========
# Create machine on which the swarm master, the registry, and the development services will run
echo "\n\nCreate machine on which the swarm master and the development services will run...\n"
docker-machine create -d virtualbox                  \
	--swarm --swarm-master                           \
	--swarm-discovery="$consul_machine_url"          \
	--engine-opt="cluster-store=$consul_machine_url" \
	--engine-opt="cluster-advertise=eth1:2376"       \
	--engine-label edu.proto.machine_env="internal"  \
	--engine-label edu.proto.ram="big-ram"           \
	--engine-label edu.proto.cpu="big-cpu"           \
	--engine-insecure-registry localhost:5000        \
	development-machine

registry_url=$(docker-machine ip development-machine):5000


#=========== Internal machine ===========
# Create machine on which the internal enactment will run
echo "\n\nCreate machine on which the internal enactment will run...\n"
docker-machine create -d virtualbox                  \
	--swarm                                          \
	--swarm-discovery="$consul_machine_url"          \
	--engine-opt="cluster-store=$consul_machine_url" \
	--engine-opt="cluster-advertise=eth1:2376"       \
	--engine-label edu.proto.machine_env="internal"  \
	--engine-insecure-registry $registry_url         \
	enactment-machine-1


#=========== External machine ===========
# Create machine on which the external enactment for wfs with space needs will run
echo "\n\nCreate machine on which the external enactment for wfs with space needs will run...\n"
docker-machine create -d virtualbox                  \
	--swarm                                          \
	--swarm-discovery="$consul_machine_url"          \
	--engine-opt="cluster-store=$consul_machine_url" \
	--engine-opt="cluster-advertise=eth1:2376"       \
	--engine-label edu.proto.machine_env="external"  \
	--engine-label edu.proto.hdd="big-hdd"           \
	--engine-insecure-registry $registry_url         \
	cloud-machine-1


#=========== Show results ===========
eval "$(docker-machine env --swarm development-machine)"

# create overlay networks
echo "\n\n Create overlay networks..."
docker network create backend_net
docker network create frontend_net
docker network create enactment_net

# show created machines and info on swarm master
docker info
echo "\n\n Created machines with the following IPs:"
docker run --rm swarm list $consul_machine_url

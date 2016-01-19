#!/bin/sh

# This script should setup the docker machines for the example scenario
# Precondition: Docker, Docker-Compose, Docker Machine and VirtualBox are installed


#=========== Discovery service machine ===========
echo "\n\nCreate machine on which the discovery service and the registry will run...\n"
docker-machine create -d=virtualbox --swarm coordination-machine
eval $(docker-machine env coordination-machine)
docker-compose -f ./consul/docker-compose.yml up -d
docker-compose -p registry -f ../_registry.yml up -d

coordination_machine_ip=$(docker-machine ip coordination-machine)
coordination_machine_url="consul://$coordination_machine_ip:8500"
registry_url=$(docker-machine ip coordination-machine):5000

docker rm -f swarm-agent
docker run -d --name swarm-agent swarm join --advertise $coordination_machine_ip:2376 consul://$coordination_machine_ip:8500

#=========== Development machine ===========
echo "\n\nCreate machine on which the swarm master and the development services will run..."
docker-machine create -d virtualbox                        \
	--swarm --swarm-master                                 \
	--swarm-discovery="$coordination_machine_url"          \
	--engine-opt="cluster-store=$coordination_machine_url" \
	--engine-opt="cluster-advertise=eth1:2376"             \
	--engine-label edu.proto.machine_env="internal"        \
	--engine-label edu.proto.ram="big-ram"                 \
	--engine-label edu.proto.cpu="big-cpu"                 \
	--engine-insecure-registry $registry_url               \
	development-machine


#=========== Internal machine ===========
echo "\n\nCreate machine on which the internal enactment will run..."
docker-machine create -d virtualbox                        \
	--swarm                                                \
	--swarm-discovery="$coordination_machine_url"          \
	--engine-opt="cluster-store=$coordination_machine_url" \
	--engine-opt="cluster-advertise=eth1:2376"             \
	--engine-label edu.proto.machine_env="internal"        \
	--engine-insecure-registry $registry_url               \
	internal-machine


#=========== External machine ===========
echo "\n\nCreate machine on which the external enactment for wfs with space needs will run..."
docker-machine create -d virtualbox                        \
	--swarm                                                \
	--swarm-discovery="$coordination_machine_url"          \
	--engine-opt="cluster-store=$coordination_machine_url" \
	--engine-opt="cluster-advertise=eth1:2376"             \
	--engine-label edu.proto.machine_env="external"        \
	--engine-label edu.proto.hdd="big-hdd"                 \
	--engine-insecure-registry $registry_url               \
	cloud-machine

docker run -d --name swarm-agent swarm join --advertise=$(docker-machine ip coordination-machine):2376 consul://$(docker-machine ip development-machine):8500

#=========== Show results ===========
eval "$(docker-machine env --swarm development-machine)"

echo "\n\n Create overlay networks..."
echo "Create backend network: $(docker network create backend_net)"
echo "Create frontend network: $(docker network create frontend_net)"
echo "Create enactment network: $(docker network create enactment_net)"

docker network connect backend_net registry_service_1
docker network connect enactment_net registry_service_1

# show created machines and info on swarm master
docker info
echo "\n\n Created machines with the following IPs:"
docker run --rm swarm list $coordination_machine_url

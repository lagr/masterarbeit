#!/bin/sh

# This script should setup the docker machines for the example scenario
# Precondition: Docker, Docker-Compose, Docker Machine and VirtualBox are installed

#=========== Discovery service machine ===========
echo "\n\nCreate machine on which the discovery service and the registry will run...\n"
docker-machine create -d=virtualbox 					  	\
	--swarm 												\
	--swarm-discovery="consul://127.0.0.1:8500"	  			\
    --engine-opt="cluster-store=consul://127.0.0.1:8500"  	\
    --engine-opt="cluster-advertise=eth1:2376"            	\
    --virtualbox-memory "2048" 								\
    --virtualbox-boot2docker-url=https://github.com/boot2docker/boot2docker/releases/download/v1.10.0-rc2-b/boot2docker.iso \
    coordination-machine

eval "$(docker-machine env coordination-machine)"
docker load -i ./images/base_images.tar # load images to coordination machine
docker-compose -p consul -f ../consul.yml up -d

coordination_machine_ip=$(docker-machine ip coordination-machine)
consul_url="consul://$coordination_machine_ip:8500"
registry_url=$(docker-machine ip coordination-machine):5000

#=========== Development machine ===========
echo "\n\nCreate machine on which the swarm master and the development services will run..."
docker-machine create -d virtualbox                        \
	--swarm --swarm-master                                 \
	--swarm-discovery="$consul_url"                        \
	--engine-opt="cluster-store=$consul_url"               \
	--engine-opt="cluster-advertise=eth1:2376"             \
	--engine-label edu.proto.machine_env="internal"        \
	--engine-label edu.proto.ram="big-ram"                 \
	--engine-label edu.proto.cpu="big-cpu"                 \
	--engine-insecure-registry $registry_url               \
	--engine-insecure-registry registry_service_1:5000     \
    --virtualbox-boot2docker-url=https://github.com/boot2docker/boot2docker/releases/download/v1.10.0-rc2-b/boot2docker.iso \
	development-machine

#=========== Internal machine ===========
echo "\n\nCreate machine on which the internal enactment will run..."
docker-machine create -d virtualbox                        \
	--swarm                                                \
	--swarm-discovery="$consul_url"                        \
	--engine-opt="cluster-store=$consul_url"               \
	--engine-opt="cluster-advertise=eth1:2376"             \
	--engine-label edu.proto.machine_env="internal"        \
	--engine-insecure-registry $registry_url               \
    --virtualbox-boot2docker-url=https://github.com/boot2docker/boot2docker/releases/download/v1.10.0-rc2-b/boot2docker.iso \
	internal-machine

#=========== External machine ===========
echo "\n\nCreate machine on which the external enactment for wfs with space needs will run..."
docker-machine create -d virtualbox                        \
	--swarm                                                \
	--swarm-discovery="$consul_url"                        \
	--engine-opt="cluster-store=$consul_url"               \
	--engine-opt="cluster-advertise=eth1:2376"             \
	--engine-label edu.proto.machine_env="external"        \
	--engine-label edu.proto.hdd="big-hdd"                 \
	--engine-insecure-registry $registry_url               \
    --virtualbox-boot2docker-url=https://github.com/boot2docker/boot2docker/releases/download/v1.10.0-rc2-b/boot2docker.iso \
	cloud-machine

#=========== Run service registrators ===========
eval "$(docker-machine env --swarm development-machine)"
echo "\n\nLoad images required by all servers from file..."
docker load -i ./images/base_images.tar

# show created machines and info on swarm master
docker info
echo "\n\n Created machines with the following IPs:"
docker run --rm swarm list $consul_url

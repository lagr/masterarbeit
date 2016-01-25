#!/bin/sh

# This script should setup the docker machines for the example scenario
# Precondition: Docker, Docker-Compose, Docker Machine and VirtualBox are installed

run_registrator () {
	docker run -d \
	    --net=host \
	    -e "constraint:node==$1" \
	    --volume=/var/run/docker.sock:/tmp/docker.sock \
	    gliderlabs/registrator:latest \
	    $consul_url
}

## TODO start registry on swarm master node and add ip tables entry


#=========== Discovery service machine ===========
echo "\n\nCreate machine on which the discovery service and the registry will run...\n"
docker-machine create -d=virtualbox --swarm coordination-machine
eval $(docker-machine env coordination-machine)
docker load -i images.tar # load images to coordination machine
docker-compose -f ./consul/docker-compose.yml up -d
docker-compose -p registry -f ../_registry.yml up -d

coordination_machine_ip=$(docker-machine ip coordination-machine)
consul_url="consul://$coordination_machine_ip:8500"
registry_url=$(docker-machine ip coordination-machine):5000

docker rm -f swarm-agent
docker run -d --name swarm-agent swarm join --advertise $coordination_machine_ip:2376 $consul_url

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
	cloud-machine

#docker rm -f swarm-agent
#docker run -d --name swarm-agent swarm join --advertise $coordination_machine_ip:2376 $consul_url
#=========== Run service registrators ===========
eval "$(docker-machine env --swarm development-machine)"

docker load -i images.tar # load images to all machines

run_registrator development-machine
run_registrator internal-machine
run_registrator cloud-machine

#=========== Show results ===========
echo "\n\n Create overlay networks..."
echo "Create backend network"
docker network create backend_net
echo "Create frontend network"
docker network create frontend_net
echo "Create enactment network"
docker network create enactment_net

sleep 1
docker network connect backend_net registry_service_1
docker network connect enactment_net registry_service_1

# show created machines and info on swarm master
docker info
echo "\n\n Created machines with the following IPs:"
docker run --rm swarm list $consul_url

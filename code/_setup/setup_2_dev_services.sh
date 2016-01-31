#!/bin/sh

# This script should setup the development and administration services
# Precondition: Environment setup was successfully executed
eval "$(docker-machine env --swarm development-machine)"
echo "Started: $(date)\n"

compose='docker-compose --x-networking'

registry_node='coordination-machine'
development_node='development-machine'
organization_node='internal-machine'
logging_node='internal-machine'

registry_url=$(docker-machine ip $registry_node):5000

switch_to () {
  eval "$(docker-machine env ${*})"
}

build_container () {
  docker build -t $1 ../$2
}

build_and_push_container () {
  build_container $1 $2
  docker tag -f $1 $registry_url/$1
  docker push $registry_url/$1
}

run_container () {
  REGISTRY=$(docker-machine ip coordination-machine):5000 \
  TARGET_NODE=$1 \
  $compose -p $2 -f ../_$3.yml up -d
}


# =========== build service images ===========
eval "$(docker-machine env development-machine)"
build_container "development_app" development_app

echo "Build wf engine service ..."
build_container "wf_engine_service" wf_engine_service

# =========== launch services ===========
eval "$(docker-machine env --swarm development-machine)"
echo "Launch mom service..."
run_container internal-machine mom mom
docker network connect enactment_net mom_service_1

eval "$(docker-machine env development-machine)"
echo "Launch development app..."
SWARM_MANAGER_IP=$(docker-machine ip development-machine) \
$compose -p development -f ../_development.yml up -d

SWARM_MANAGER_IP=$(docker-machine ip development-machine) \
$compose -p wfengine -f ../_wf_engine.yml up -d

eval "$(docker-machine env --swarm development-machine)"
docker network connect backend_net development_app_1
docker network connect enactment_net wfengine_service_1


echo "\nFinished: $(date)\n"

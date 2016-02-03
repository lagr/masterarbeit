#!/bin/sh
# This script should setup the development and administration services
# Precondition: Environment setup was successfully executed
echo "Started: $(date)\n"

eval "$(docker-machine env --swarm development-machine)"

#compose='docker-compose --x-networking'
compose='docker-compose'
registry_url=$(docker-machine ip coordination-machine):5000

# =========== build service images ===========
eval "$(docker-machine env development-machine)"
#docker load -i ./images/development.tar
docker build -t "development_app" ../development_app

echo "Build wf engine service ..."
#docker load -i ./images/wfengine.tar
docker build -t "wf_engine_service" ../wf_engine_service

# =========== build base images ===========
#docker load -i ./images/wf_base_images.tar
docker build -t "wf_base" ../wf_base
docker build -t "ac_base" ../ac_base

# =========== launch services ===========
eval "$(docker-machine env --swarm development-machine)"
TARGET_NODE=coordination-machine \
$compose -p registry -f ../_registry.yml up -d

docker network connect backend_net registry_service_1

echo "Launch message_broker service..."
REGISTRY=$registry_url \
TARGET_NODE=internal-machine \
$compose -p message_broker -f ../_message_broker.yml up -d

docker network connect enactment_net messagebroker_service_1

eval "$(docker-machine env development-machine)"
echo "Launch development app..."
REGISTRY=$registry_url \
SWARM_MANAGER_IP=$(docker-machine ip development-machine) \
$compose -p development -f ../_development.yml up -d

REGISTRY=$registry_url \
SWARM_MANAGER_IP=$(docker-machine ip development-machine) \
$compose -p wfengine -f ../_wf_engine.yml up -d

eval "$(docker-machine env --swarm development-machine)"
docker network connect backend_net development_app_1
docker network connect enactment_net wfengine_service_1

echo "\nFinished: $(date)\n"

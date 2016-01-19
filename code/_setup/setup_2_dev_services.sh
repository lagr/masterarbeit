#!/bin/sh

# This script should setup the development and administration services
# Precondition: Environment setup was successfully executed
compose='docker-compose --x-networking'

registry_node='coordination-machine'
development_node='development-machine'
organization_node='internal-machine'
logging_node='internal-machine'

switch_to () {
  eval "$(docker-machine env ${*})"
}

run_container () {
  echo "---"
  echo "$1"
  echo "$2"
  echo "$3"
  echo "---"
  REGISTRY=$(docker-machine ip coordination-machine):5000 \
  TARGET_NODE=$1 \
  $compose -p $2 -f ../_$3.yml up -d
}


# =========== pull base images ===========
#switch_to development-machine
eval "$(docker-machine env development-machine)"

docker pull cogniteev/echo
docker pull alpine
docker pull registry:2
docker pull postgres
docker pull ruby:2.2


# =========== build service images ===========
docker build -t "development_app" ../development_app

docker build -t "organization_service" ../organization_service
docker tag -f organization_service $(docker-machine ip $registry_node):5000/organization_service
docker push $(docker-machine ip $registry_node):5000/organization_service

# =========== launch services ===========
echo "Build and launch development app..."
#docker build -t "development_app" ../development_app
$compose -p development -f ../_development.yml up -d

eval "$(docker-machine env --swarm development-machine)"
#switch_to --swarm development-machine

echo "Build and launch organization service..."
#docker build -t "organization_service" ../organization_service

#docker tag organization_service $(docker-machine ip $registry_node):5000/organization_service
#docker push $(docker-machine ip $registry_node):5000/organization_service
#docker -H $(docker-machine ip $organization_node):2376 pull $(docker-machine ip $registry_node):5000/organization_service

# REGISTRY=$(docker-machine ip $registry_node):5000 \
# TARGET_NODE=$organization_node \
# $compose -p organization -f ../_organization.yml up -d
run_container $organization_node organization organization

sleep 5
docker exec -it organization_service_1 rake db:migrate:reset db:seed

# === Logging service
# echo "\n\nBuild and launch logging service..."
# docker build \
#   --build-arg="constraint:node==$logging_node" \
#   -t "localhost:5000/logging_service" \
#   ../logging_service

# docker push localhost:5000/logging_service
# docker -H $(docker-machine ip $logging_node):2376 pull $(docker-machine ip $registry_node):5000/logging_service

run_container $logging_node logging logging
# REGISTRY=$(docker-machine ip $registry_node):5000 \
# TARGET_NODE=$logging_node \
# $compose -p logging -f ../_logging.yml up -d

docker network connect backend_net logging_service_1

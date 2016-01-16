#!/bin/sh

# This script should setup the development and administration services
# Precondition: Environment setup was successfully executed

# create overlay networks
eval "$(docker-machine env --swarm development-machine)"
docker network create organization_net
docker network create dev_net
docker network create logging_net
docker network create enactment_net

# launch services
eval "$(docker-machine env development-machine)"
docker-compose --x-networking -p registry     -f ../_registry.yml     up -d
docker-compose --x-networking -p organization -f ../_organization.yml up -d
docker-compose --x-networking -p logging      -f ../_logging.yml      up -d
docker-compose --x-networking -p development  -f ../_development.yml  up -d
docker-compose --x-networking -p wf_engine    -f ../_wf_engine.yml    up -d

# since compose does not support multiple networks yet, the other networks must be assigned manually
eval "$(docker-machine env --swarm development-machine)"
docker network connect organization_net development_app_1
docker network connect organization_net wf_engine_service_1

docker network connect engine_net registry_registry_1

docker network connect logging_net wf_engine_service_1
docker network connect logging_net development_app_1

docker network connect enactment_net registry_registry_1
docker network connect enactment_net development_app_1
docker network connect enactment_net development_app_1




#!/bin/sh
# This script should setup the development and administration services
# Precondition: Environment setup was successfully executed
step(){
	echo "\n\n$@"
}

SWARM_MANAGER_IP=$(docker-machine ip development-machine)

step "Build base images.."
eval "$(docker-machine env development-machine)"
docker build -t "wf_base" ../wf_base
docker build -t "ac_base" ../ac_base

step "Start services.."
eval "$(docker-machine env --swarm development-machine)"
docker-compose -p wfms -f ../wfms.yml build development_app engine
docker-compose -p wfms -f ../wfms.yml up -d


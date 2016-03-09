#!/bin/sh
# This script should setup the development and administration services
# Precondition: Environment setup was successfully executed
step(){
	echo "\n\n$@"
}

step "Build base images.."
eval "$(docker-machine env development-machine)"
docker build -t "wf_base" ../wf_base
docker build -t "ac_base" ../ac_base

step "Start services.."
eval "$(docker-machine env --swarm development-machine)"
docker-compose -p wfms -f ../wfms.yml up -d

sleep 10 # wait for the databases to be started and create the tables
docker exec wfms_organization_1 rake wfms:setup_db
docker exec wfms_definition_1 rake wfms:setup_db
docker exec wfms_worklist_1 rake wfms:setup_db

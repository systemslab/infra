#!/bin/bash
set -e
set -x

if [ $(basename `pwd`) != "infra" ]; then fail "Please cd to infra"; fi

# configure infra to use Travis-ci's Docker version
IMAGE="michaelsevilla/emaster:1.7.1"
INFRA="`pwd`"
TRAVIS_ARGS="--extra-vars \"image=michaelsevilla/emaster:1.7.1 docker_api_version=1.20\""

# configure the hosts file
cp hosts.template hosts
sed -i "s/<USERNAME>/${USER}/g" hosts
cat hosts

# mimic bin/emaster.sh
source $INFRA/bin/env.sh
docker run $ARGS -d --entrypoint=/bin/bash $IMAGE 
docker exec emaster cp /infra/hosts /tmp/hosts
docker exec emaster /bin/bash -c "touch ~/.ssh/config; chmod 600 ~/.ssh/config; chown root ~/.ssh/config"
docker exec emaster /bin/bash -c "cd /infra/roles/emaster; ansible-playbook $TRAVIS_ARGS start.yml"
docker exec emaster sed -i 's/ansible_ssh_user=[^=]*$/ansible_ssh_user=root\ /g' /tmp/hosts
docker exec emaster /bin/bash -c "echo \"PORT 2223\" >> /etc/ssh/ssh_config"

# run the job
docker exec emaster /bin/bash -c "cd $DIR; ansible-playbook $TRAVIS_ARGS $JOB"

#!/bin/bash
# This mimics the Travis build script

if [ -z $JOB ]; then
  echo "ERROR: JOB is not specified; pick one from experiments directory"
  echo "  JOB=\"ceph\" $0"
  exit 1
fi

# emulate a clean Travis environment
docker rm --force `docker ps -qa`
set -e
set -x

# all experiments must have an experiment.yml file
cd $JOB/test

# setup the hosts configuration file
cp hosts.template hosts

# TEST: Experiment Syntax
ansible-playbook --syntax-check site/cleanup.yml experiment.yml

# TEST: Experiment Deploy
ansible-playbook --connection=local experiment.yml
docker rm --force `docker ps -qa`
ansible-playbook --connection=local site/cleanup.yml

# TEST: Experiment Deploy Idempotence
ansible-playbook --connection=local experiment.yml
docker rm --force `docker ps -qa`
ansible-playbook --connection=local site/cleanup.yml

# TEST: Experiment Cleanup Idempotence
ansible-playbook --connection=local site/cleanup.yml | grep -q 'changed=0.*failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)

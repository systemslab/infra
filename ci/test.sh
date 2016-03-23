#!/bin/bash

# this mimics the Travis build script

set -e

if [ -z $JOB ]; then
  echo "ERROR: JOB is not specified"
  echo "  JOB=\"experiments/ceph-experiments/radosbench\" ci/test.sh"
  exit 1
fi

set -x

# all experiments must have an experiment.yml file
cd $JOB

# setup the hosts configuration file
cp hosts.template hosts

# TEST: Experiment Syntax
ansible-playbook experiment.yml --syntax-check
ansible-playbook cleanup.yml --syntax-check

# TEST: Experiment Deploy
ansible-playbook --become --connection=local experiment.yml

# TEST: Experiment Deploy Idempotence
docker rm --force `docker ps -qa`
ansible-playbook --become --connection=local cleanup.yml
ansible-playbook --become --connection=local experiment.yml

# TEST: Experiment Cleanup Idempotence
docker rm --force `docker ps -qa`
ansible-playbook --become --connection=local cleanup.yml
ansible-playbook --become --connection=local cleanup.yml | grep -q 'changed=0.*failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)

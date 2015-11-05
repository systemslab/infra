#!/bin/bash

# Test standalone ceph
../bin/cleanup.sh
docker run -it --rm \
    --name="test" \
    --net=host \
    --volume="$(dirname `pwd`):/infra/" \
    --volume="/tmp/:/tmp/" \
    --volume="/etc/ceph:/etc/ceph" \
    --workdir="/infra/experiments/localhost" \
    --volume="/var/run/docker.sock:/var/run/docker.sock" \
    --privileged \
    michaelsevilla/emaster \
    ansible-playbook cephdev-experiment.yml

# Test standalone tachyon
../bin/cleanup.sh
docker run -it --rm \
    --name="test" \
    --net=host \
    --volume="$(dirname `pwd`):/infra/" \
    --volume="/tmp/:/tmp/" \
    --volume="/etc/ceph:/etc/ceph" \
    --workdir="/infra/experiments/localhost" \
    --volume="/var/run/docker.sock:/var/run/docker.sock" \
    --privileged \
    michaelsevilla/emaster \
    ansible-playbook tachyondev-experiment.yml

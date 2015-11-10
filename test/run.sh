#!/bin/bash

ARGS="-it --rm \
      --name=\"test\"\
      --net=host \
      --volume=\"/tmp/:/tmp/\" \
      --volume=\"/etc/ceph:/etc/ceph\" \
      --volume=\"/var/run/docker.sock:/var/run/docker.sock\"
      --volume=\"$(dirname `pwd`):/infra\" \
      --workdir=\"/infra/experiments/localhost\" \
      --privileged"
EMASTER="michaelsevilla/emaster"

# Test standalone ceph
docker run $ARGS $EMASTER ansible-playbook ceph.yml
docker run $ARGS $EMASTER ansible-playbook zlog.yml
docker run $ARGS $EMASTER ansible-playbook tachyon.yml

## Test standalone tachyon
#docker run -it --rm \
#    --name="test" \
#    --net=host \
#    --volume="$(dirname `pwd`):/infra/" \
#    --volume="/tmp/:/tmp/" \
#    --volume="/etc/ceph:/etc/ceph" \
#    --workdir="/infra/experiments/localhost" \
#    --volume="/var/run/docker.sock:/var/run/docker.sock" \
#    --privileged \
#    michaelsevilla/emaster \
#    ansible-playbook tachyondev-experiment.yml
#
#

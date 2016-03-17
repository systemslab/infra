#! /bin/bash
# Author: Michael Sevilla

KEY=`cat ~/.ssh/id_rsa.pub`

ARGS="-t \
      --name=\"emaster\"\
      --net=host \
      --volume=\"/tmp/:/tmp/\" \
      --volume=\"/usr/hdp/:/usr/hdp/\" \
      --volume=\"/var/run/docker.sock:/var/run/docker.sock\" \
      --volume=\"$INFRA:/infra\" \
      --volume=\"$HOME/.ssh:/root/.ssh\" \
      --volume=\"/etc/ceph:/etc/ceph\" \
      --volume=\"/var/lib/ceph:/var/lib/ceph\" \
      --workdir=\"/infra/roles\" \
      --privileged"





#! /bin/bash

docker ps -aq | xargs docker rm -f
if [ "$1" == "remove" ]; then
    docker images -aq | xargs docker rmi -f
fi

rm -r /tmp/docker /etc/ceph/* >> /dev/null 2>&1

#! /bin/bash

docker ps -aq | xargs docker rm -f
if [ "$1" == "remove" ]; then
    docker images -aq | xargs docker rmi -f
    sudo rm -r /tmp/docker
fi

sudo rm -r /etc/ceph/* >> /dev/null 2>&1

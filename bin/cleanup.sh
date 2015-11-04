#! /bin/bash

docker ps -aq | xargs docker rm -f >> /dev/null 2>&1
if [ "$1" == "remove" ]; then
    docker images -aq | xargs docker rmi -f >> /dev/null 2>&1
    sudo rm -r /tmp/docker >> /dev/null 2>&1
fi

sudo rm -r /etc/ceph/* /var/lib/ceph/* >> /dev/null 2>&1
exit 0

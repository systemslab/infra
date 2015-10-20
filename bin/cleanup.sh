#! /bin/bash

docker ps -aq | xargs docker rm -f
if [ "$1" == "remove" ]; then
    docker images -aq | xargs docker rmi -f
fi

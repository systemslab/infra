#!/bin/bash
docker rm -f jenkins >> /dev/null 2>&1

set -ex
docker run -d \
  --name jenkins \
  --net host \
  -v ~/.ssh/:/root/.ssh \
  -v /var/jenkins_home:/var/jenkins_home \
  michaelsevilla/jenkins

docker exec -it jenkins /bin/bash

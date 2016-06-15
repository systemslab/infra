#!/bin/bash
docker rm -f jenkins >> /dev/null 2>&1

set -ex
docker run -d \
  --name jenkins \
  --net host \
  -v ~/.ssh/:/root/.ssh \
  -v /user/jenkins_home:/var/jenkins_home \
  -v /user:/user \
  -v `pwd`/cluster:/cluster \
  michaelsevilla/jenkins

docker exec jenkins cp /cluster/hosts /etc/ansible/hosts
docker exec jenkins cp /cluster/ansible.cfg /etc/ansible/ansible.cfg
docker exec jenkins cp /root/.ssh/id_rsa /tmp/private_key
docker exec jenkins chmod 777 /tmp/private_key 
docker exec jenkins service apache2 start
docker exec -it jenkins /bin/bash

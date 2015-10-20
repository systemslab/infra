#! /bin/bash

#sudo apt-get update
#sudo apt-get install python-setuptools
#sudo easy_install pip
#sudo pip install docker-py

# clear out existing docker containers
./cleanup.sh >> /dev/null 2>&1
mkdir /tmp/docker >> /dev/null 2>&1
echo "Installing an Ansible Docker container and dropping you into an 'experiment shell'"
docker run -it \
  --name="emaster" \
  --hostname="experiment_master" \
  --volume="$(dirname `pwd`):/hathisar-dev/" \
  --volume="/tmp/:/tmp/" \
  --workdir="/hathisar-dev/experiments" \
  michaelsevilla/emaster \
  ansible-playbook -k ../roles/emaster/tasks/pushkeys.yml

docker rm emaster

docker run -it \
  --name="emaster" \
  --hostname="experiment_master" \
  --volume="$(dirname `pwd`):/hathisar-dev/" \
  --volume="/tmp/:/tmp/" \
  --workdir="/hathisar-dev/experiments" \
  michaelsevilla/emaster \
  /bin/bash
#! /bin/bash

# clear out existing docker containers
./cleanup.sh >> /dev/null 2>&1
mkdir /tmp/docker >> /dev/null 2>&1
echo "Installing an Ansible Docker container and dropping you into an 'experiment shell'"
docker run -it \
  --name="emaster" \
  --net=host \
  --volume="$(dirname `pwd`):/hathisar-dev/" \
  --workdir="/hathisar-dev/experiments" \
  michaelsevilla/emaster \
  ansible-playbook -k ../roles/emaster/tasks/pushkeys.yml

if [ "$?" -ne 0 ]; then
  echo "... wrong password? Try again."
  exit 
fi

docker rm emaster

echo "==============================================================================="
echo "You are now in an experiment master shell!"
echo "==============================================================================="
docker run -it \
  --name="emaster" \
  --net=host \
  --volume="$(dirname `pwd`):/hathisar-dev/" \
  --volume="/tmp/:/tmp/" \
  --volume="/etc/ceph:/etc/ceph" \
  --workdir="/hathisar-dev/experiments" \
  michaelsevilla/emaster \
  /bin/bash


#! /bin/bash

# Ascii art: http://www.network-science.de/ascii/; font is "big"
function fail() {
  echo "==============================================================================="
cat << "EOF"
 ______      _  _            _ 
|  ____|    (_)| |          | |
| |__  __ _  _ | |  ___   __| |
|  __|/ _` || || | / _ \ / _` |
| |  | (_| || || ||  __/| (_| |
|_|   \__,_||_||_| \___| \__,_|
EOF
  echo "==============================================================================="
  exit 1
}

if [ -z "$1" ]; then
  CLUSTER="localhost"
else
  CLUSTER="$1"
fi
echo "===> Experiment master will control all hosts listed in $CLUSTER"

if [ ! -d "../experiments/$CLUSTER" ]; then
  echo "===> Couldn't find directory with hosts listed in ../experiments/$CLUSTER"
  fail
fi

echo "===> Cleaning up old docker containers - this may require a sudo password"
./cleanup.sh >> /dev/null 2>&1
mkdir -p /tmp/docker/src /tmp/docker/deploy >> /dev/null 2>&1

echo "===> Installing an Ansible Docker container and dropping you into an 'experiment shell'"
docker run -it --rm \
  --name="emaster" \
  --net=host \
  --volume="$(dirname `pwd`):/infra/" \
  --workdir="/infra/experiments/$CLUSTER" \
  --privileged \
  michaelsevilla/emaster \
  ansible-playbook -k ../../roles/emaster/tasks/pushkeys.yml

if [ "$?" -ne 0 ]; then
  echo "===> ... wrong password? Try again."
  fail
fi

echo "===> Here are the specs of your environment:"
docker run -it --rm \
  --name="emaster" \
  michaelsevilla/emaster \
  cat /etc/*release

echo "==============================================================================="
echo "===> You are now in an experiment master shell!"
cat << "EOF"
 ______                           _                          _   
|  ____|                         (_)                        | |  
| |__   __  __ _ __    ___  _ __  _  _ __ ___    ___  _ __  | |_ 
|  __|  \ \/ /| '_ \  / _ \| '__|| || '_ ` _ \  / _ \| '_ \ | __|
| |____  >  < | |_) ||  __/| |   | || | | | | ||  __/| | | || |_ 
|______|/_/\_\| .__/  \___||_|   |_||_| |_| |_| \___||_| |_| \__|
 _    _       |_|                                                
|  \/  |             _              
| \  / |  __ _  ___ | |_  ___  _ __ 
| |\/| | / _` |/ __|| __|/ _ \| '__|
| |  | || (_| |\__ \| |_|  __/| |   
|_|  |_| \__,_||___/ \__|\___||_|   
EOF
echo "==============================================================================="
docker run -it --rm \
  --name="emaster" \
  --net=host \
  --volume="$(dirname `pwd`):/infra/" \
  --volume="/tmp/:/tmp/" \
  --volume="/etc/ceph:/etc/ceph" \
  --workdir="/infra/experiments/$CLUSTER" \
  --volume="/var/run/docker.sock:/var/run/docker.sock" \
  --privileged \
  michaelsevilla/emaster \
  /bin/bash

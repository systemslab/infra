#! /bin/bash
# Author: Michael Sevilla
# Start the experiment master as a container running in the background
docker stop emaster eslave; docker rm emaster eslave
set -e

# Change this if you have an older docker image
IMAGE="michaelsevilla/emaster:1.7.1"
DOCKER="1.19"

# Start Functions
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
  echo -e "\n===> $1"
  echo "==============================================================================="
  exit 1
}


# Start Main
echo "===> Check some variables"
if [ $(basename `pwd`) == "bin" ]; then 
  echo "===> You are in bin."
  INFRA="$(dirname `pwd`)"
elif [ $(basename `pwd`) == "infra" ]; then
  echo "===> You are in infra."
  INFRA="`pwd`"
else
  fail "Not sure which directory you are in. Please cd to infra or infra/bin"
fi
echo "===> Attaching full path: $INFRA"
if [ ! -e "$INFRA/hosts" ]; then
  fail "Couldn't find a hosts file, please read the README.md"
fi

EXTRA_ARGS="--extra-vars \"image=michaelsevilla/emaster:1.7.1 docker_api_version=1.19 infra=$INFRA\""
source $INFRA/bin/env.sh

RUNNING=`docker ps -a`
if [[ $RUNNING == *"emaster"* ]]; then
  fail "An emaster or eslave is already running. Either kill it or use it."
fi

echo "===> Figure out which screen to use"
SCREEN=`echo $DISPLAY | sed s/localhost//g | sed 's/\.0//g'`
if [ -z "$SCREEN" ]; then
  read -p "     Couldn't find a screen, so you can't use the graphers... do you want to continue [y/n]? " answer
  if [ "$answer" == 'n' ]; then
    echo "     To get a screen, use: [ssh -X user@hostname]"
    exit 1
  fi
else
  XAUTH=`xauth list | grep $SCREEN`
  #ARGS="$ARGS \
  #    -e DISPLAY=$DISPLAY \
  #    -v /tmp/.X11-unix:/tmp/.X11-unix \
  #    -e XAUTH=$XAUTH"
fi

echo "===> Experiment master will control all hosts listed in /infra/hosts"
docker run $ARGS -d --entrypoint=/bin/bash $IMAGE 
docker exec -it emaster cp /infra/hosts /tmp/hosts
docker exec -it emaster /bin/bash -c "cd /infra/roles/emaster; ansible-playbook -k $EXTRA_ARGS start.yml"
docker exec emaster sed -i 's/ansible_ssh_user=[^=]*$/ansible_ssh_user=root\ /g' /tmp/hosts

if [ "$?" -ne 0 ]; then
  fail "... wrong password? Try again."
fi

echo "==============================================================================="
echo "===> Here are the specs of your environment:"
docker exec emaster cat /etc/lsb-release /etc/os-release | while read p; do echo -e "\t $p"; done
docker exec emaster /bin/bash -c "echo \"export PS1=[EXPERIMENT_MASTER]\  \">> /root/.bashrc"
docker exec emaster /bin/bash -c "echo \"PORT 2223\" >> /etc/ssh/ssh_config"
docker exec -it emaster /bin/bash

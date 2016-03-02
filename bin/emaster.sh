#! /bin/bash

# Start global variables
if [ $(basename `pwd`) == "bin" ]; then 
  echo "===> You are in bin."
  INFRA="$(dirname `pwd`)"
elif [ $(basename `pwd`) == "infra" ]; then
  echo "===> You are in infra."
  INFRA="`pwd`"
else
  echo "===> Not sure which directory you are in. Please cd to infra or infra/bin"
  exit 0
fi
echo "===> Attaching full path: $INFRA"

ARGS="-t \
      --name=\"emaster\"\
      --net=host \
      --volume=\"/tmp/:/tmp/\" \
      --volume=\"/usr/hdp/:/usr/hdp/\" \
      --volume=\"/etc/ceph:/etc/ceph\" \
      --volume=\"/var/lib/ceph:/var/lib/ceph\" \
      --volume=\"/var/run/docker.sock:/var/run/docker.sock\" \
      --volume=\"$INFRA:/infra\" \
      --workdir=\"/infra/roles\" \
      --privileged"
# End global variables

# Start functions
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
# End functions

# main
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
  ARGS="$ARGS \
      -e DISPLAY=$DISPLAY \
      -v /tmp/.X11-unix:/tmp/.X11-unix"
fi

echo "===> Cleaning up old docker containers - this may require a sudo password"
if [ -e ./cleanup.sh ]; then
  ./cleanup.sh >> /dev/null 2>&1
elif [ -e ./bin/cleanup.sh ]; then
  ./bin/cleanup.sh >> /dev/null 2>&1
else
  echo "===> ... couldn't find a cleanup script. Try again."
  fail
fi
  

echo "===> Experiment master will control all hosts listed in /infra/hosts"
docker run $ARGS -i --rm michaelsevilla/emaster ansible-playbook -k /infra/roles/emaster/tasks/pushkeys.yml

if [ "$?" -ne 0 ]; then
  echo "===> ... wrong password? Try again."
  fail
fi

echo "==============================================================================="
echo "===> Here are the specs of your environment:"
docker run $ARGS -i --rm michaelsevilla/emaster cat /etc/lsb-release /etc/os-release | while read p; do echo -e "\t $p"; done
docker run $ARGS -d -e "XAUTH=$XAUTH" michaelsevilla/emaster /bin/emaster-shell

echo "===> Your emaster container has been started in the background"
echo "===> To go into it, use: docker exec -it emaster /bin/bash"

#! /bin/bash
# Author: Michael Sevilla
# Start the experiment master and drop the user into the container

docker rm -f emaster >> /dev/null 2>&1
set -e

# initial docker arguments
ARGS="--name=emaster --net=host --rm -it --workdir=/infra/experiments -v ${HOME}/.ssh:/root/.ssh"

# figure out which directory we're in
if [ $(basename `pwd`) == "bin" ]; then 
  ARGS="$ARGS --volume=\"$(dirname `pwd`):/infra\""
elif [ $(basename `pwd`) == "infra" ]; then
  ARGS="$ARGS --volume=\"`pwd`:/infra\""
else
  echo "===> ERROR: Please cd to infra or infra/bin"
  exit 1
fi

# check for a screen
SCREEN=`echo $DISPLAY | sed s/localhost//g | sed 's/\.0//g'`
if [ ! -z "$SCREEN" ]; then
  XAUTH=`xauth list | grep $SCREEN`
  ARGS="$ARGS \
      -e DISPLAY=$DISPLAY \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      -e XAUTH=$XAUTH"
fi

docker run $ARGS michaelsevilla/emaster

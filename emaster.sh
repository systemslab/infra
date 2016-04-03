#!/bin/bash

set -e
set -x

docker run --rm -it \
  --name="emaster" \
  --net=host \
  -v `pwd`:/infra \
  -v /tmp:/tmp \
  -v ~/.ssh:/root/.ssh \
  --workdir=/infra \
  michaelsevilla/emaster

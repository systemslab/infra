#!/bin/bash
docker run \
  --name remote0 \
  -d \
  -e SSHD_PORT=2222 \
  -e AUTHORIZED_KEYS="`cat ~/.ssh/id_rsa.pub`" \
  --net=host \
  --cap-add=SYS_ADMIN --privileged \
  michaelsevilla/hathisar-dev

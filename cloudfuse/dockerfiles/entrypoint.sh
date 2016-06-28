#!/bin/bash
set -x

for ENVAR in "USERNAME" "TENANT" "PASSWORD" "AUTHURL"; do
  env | grep $ENVAR
  if [ $? -eq 1 ]; then
    echo "ERROR: please set the $ENVAR environment variable"
    exit 1;
  fi
done

echo "
username=$USERNAME
tenant=$TENANT
password=$PASSWORD
authurl=$AUTHURL" > ~/.cloudfuse

mkdir /mnt/cloudfuse
cloudfuse -d /mnt/cloudfuse

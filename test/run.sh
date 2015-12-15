#!/bin/bash
ARGS="-it --rm \
      --name=\"test\"\
      --net=host \
      --volume=\"/tmp/:/tmp/\" \
      --volume=\"/etc/ceph:/etc/ceph\" \
      --volume=\"/var/run/docker.sock:/var/run/docker.sock\" \
      --volume=\"$(dirname `pwd`):/infra\" \
      --workdir=\"/infra/experiments/\" \
      --privileged"
EMASTER="michaelsevilla/emaster"

echo "Cleaning up..."
../bin/cleanup.sh
sudo chown -R msevilla:msevilla ../
sudo rm -r /tmp/docker >> /dev/null 2>&1

echo "Setup emaster environment..."
docker run $ARGS $EMASTER ansible-playbook -k ../roles/emaster/tasks/pushkeys.yml

OUTPUT=`date +%m-%d-%y_%T`
mkdir -p out/${OUTPUT} >> /dev/null 2>&1

echo "Starting tests..."
for f in `ls ../experiments/*.yml`; do
  EXPERIMENT=`basename $f`
  ../bin/cleanup.sh
  echo -e "\t- Testing: $EXPERIMENT"
  docker run $ARGS $EMASTER ansible-playbook $EXPERIMENT >> out/${OUTPUT}/${EXPERIMENT}.out
done


#!/bin/bash

set -ex

cd /opt/graphite
if [ -d "/tmp/graphite-conf" ]; then
  cp /tmp/graphite-conf/carbon.conf conf/
  cp /tmp/graphite-conf/storage-schemas.conf conf/
  cp /tmp/graphite-conf/dashboard.conf conf/dashboard.conf
else
  cp conf/carbon.conf.example conf/carbon.conf
  cp conf/storage-schemas.conf.example conf/storage-schemas.conf
  cp conf/dashboard.conf.example conf/dashboard.conf
fi

sed -i "s/Listen 80/Listen $APACHE_PORT/g" /etc/apache2/ports.conf
service apache2 start

./bin/carbon-cache.py start
./bin/run-graphite-devel-server.py /opt/graphite

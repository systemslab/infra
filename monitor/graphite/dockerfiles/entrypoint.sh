#!/bin/bash

service apache2 stop
set -ex

cd /opt/graphite

for CONF in carbon storage-schemas dashboard; do
  if [ -f /tmp/graphite/conf/$CONF.conf ]; then
    cp /tmp/graphite/conf/$CONF.conf conf/$CONF.conf
  else
    cp conf/$CONF.conf.example conf/$CONF.conf
  fi
done

sed -i "s/Listen 80/Listen $APACHE_PORT/g" /etc/apache2/ports.conf
service apache2 restart

./bin/carbon-cache.py start
./bin/run-graphite-devel-server.py --port $WEBUI_PORT /opt/graphite

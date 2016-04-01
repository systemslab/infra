#! /bin/bash

set -e
set -x

wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm 
sudo rpm -ivh epel-release-7-5.noarch.rpm

echo "* soft memlock unlimited" >> /etc/security/limits.conf
echo "* hard memlock unlimited" >> /etc/security/limits.conf
ulimit -l unlimited

sudo yum update -y
curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker ${USER}

sudo yum reinstall -y polkit
sudo systemctl start polkit
sudo service docker start

# check that everything install smoothly
ulimit -l | grep unlimited
docker ps | grep IMAGE

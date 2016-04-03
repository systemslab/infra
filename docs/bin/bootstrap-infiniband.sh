#! /bin/bash

set -e
set -x

# install EPEL and Docker
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm 
sudo rpm -ivh epel-release-7-5.noarch.rpm
sudo yum update -y
curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker ${USER}

# workaround for a Centos bug
sudo yum reinstall -y polkit
sudo systemctl start polkit
sudo service docker start

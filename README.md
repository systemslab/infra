============================================
Infra: a framework for deploying systems and running experiments
============================================

This is the SRL's infrastructure repository. Originally, it was called "Hathisar - the Hadoop integration testing framework". 

    ./test.sh

``hathisar`` is an automation framework for Hadoop, written in Bash and Python. It contains scripts for deploying object stores (e.g., Swift), connecting them to Hadoop, running Hadoop jobs, and graphing results. It is based on Ceph's `teuthology <https://github.com/ceph/teuthology>`__ test framework. 

`Hathisars <http://www.asesg.org/PDFfiles/Gajah/23-01-Glossary.pdf>`__ are elephant stables managed by mahout families in Nepal.

Directory Structure
========

- ``experiments``: where you go to launch experiments. The user should only have to cd to this directory.

- ``deploy``: scripts for deploying the systems and running experiments using Ansible.

- ``images``: scripts for installing the systems using containers. Stuff in here gets built into an image and automatically uploaded to the Docker Hub.

- ``bin``: scripts that orchestrate the Experiment Master.

Setup
========

1. On all nodes, install Docker using their directions `here <https://docs.docker.com/installation/>`__
#. On the node that this code is on (i.e., our ``experiment master``), run: ./deploy/master.sh
- this will instantiate an Ansible Docker container

FAQ
========

Q: Why is this all so insecure

A: Because I couldn't figure out how to initialize docker containers with specific SSH keys

Q: The container fails to pull down Ubuntu repos and can't seem to reach the internet.

A: This connectivity issue [1] is fixed with:
sudo apt-get install bridge-utils
pkill docker
iptables -t nat -F
ifconfig docker0 down
brctl delbr docker0
sudo service docker start


Q: On Centos6, I get:
NameError: global name 'DEFAULT_DOCKER_API_VERSION' is not defined

A: Centos6 is not supported but a workaround [2] is to yum install python-docker-py.x86_64

Q: I'm getting error for "chpasswd: (user root) pam_chauthtok() failed, error: System error"

A: This is a kernel bug, according to [3].

[1] http://serverfault.com/questions/642981/docker-containers-cant-resolve-dns-on-ubuntu-14-04-desktop-host
[2] https://github.com/ansible/ansible-modules-core/issues/1792
[3] https://github.com/docker/docker/issues/5704


TODO: Figure out how to run sudo! Pull down the container and figure out how to get the tachyon container to launch wtih sudo

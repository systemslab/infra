============================================
Infra: a framework for running experiments
============================================

This is the SRL's infrastructure repository for reproducibly running experiments.

Install
======

On all nodes, [install Docker](https://docs.docker.com/engine/installation/).

Quickstart
==========

1. Tell me about your cluster:

   ```bash
   cp hosts.example experiments/hosts; vim experiments/hosts
   ```

2. Start an ``experiment master``:

    ```bash
     bin/emaster.sh
     ```

3. Run an experiment:

    ```bash
    ansible-playbook ceph.yml
    ```

Description
===========

The experiment master orchestrates installation/deployment and runs experiments using Ansible. Nodes install packages using Docker images. When launching the experiment master, a Docker images with Ansible is pulled/installed and sets up passwordless login. To push the keys the script asks for a password.

Each system has two roles, for example foo and foo-build. The foo-build role builds code that is already sitting in a directory*. The foo role pushes the code to the remote node and launches, unarchives it, and attaches a container to the code base. Then it starts the container and starts the daemons for the service in the container.

* We don't pull the code because some of the repositories we clone from are private and setting up the keys is a pain.

Motivation
==========

- Reproducibility: exchanging code and starting the systems for another person
- Tuning and Benchmarking: running jobs overnight and fully utilizing the cluster
- Performance Bug Fixes: automatically test multiple code revisions
- Isolation: system libraries do not interfere with each other

Development
===========
The directory looks like this:

``infra``
- ``bin``: scripts that orchestrate the Experiment Master.
- ``experiments``: where you go to launch experiments. 
- ``roles``: scripts (used by Ansible) that add services to nodes.
- ``test``: re-run all experiments.

Writing Roles
---------------
Roles have 2 components:

1. install: Docker image with the environment and packages

2. deploy: Ansible scripts (``*.yml``) that bring the system up

Installing Roles
----------------
Drop the role into the ``roles`` directory and then put an experiment yml file into ``experiments`` that uses that role.

Troubleshooting
---
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

A: This is a kernel bug, according to [3]. Get out of the 3.13 kernel.

[1] http://serverfault.com/questions/642981/docker-containers-cant-resolve-dns-on-ubuntu-14-04-desktop-host
[2] https://github.com/ansible/ansible-modules-core/issues/1792
[3] https://github.com/docker/docker/issues/5704


Q: Sometimes the Ceph daemons enter standby mode because they can't grab a resource in /var/lib/ceph

A: Sometimes docker gets hung up and won't handle the virtual volumes correctly. To fix this:

    sudo docker restart

Q: The docker container (during the build process) can't reach the internet

A: Docker doesn't do well behind proxies -- you need to tell it who to ping:

     echo "DOCKER_OPTS=\"--dns 15.214.0.20\"" >> /etc/default/docker
     sudo service docker restart

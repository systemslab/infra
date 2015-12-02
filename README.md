============================================
Infra: a framework for deploying systems and running experiments
============================================

This is the SRL's infrastructure repository. 

Install
======

On all nodes, [install Docker](https://docs.docker.com/installation). 

Quickstart
==========
It's as easy as 1, 2, 3.

1. Specify the hosts and drop it in the experiment folder:

   ```bash
   cp hosts.example experiments/hosts; vim experiments/hosts
   ```

2. On this node, start an ``experiment master``:

    ```bash
     cd bin; ./emaster.sh
     ```

3. Run an experiment:

    ```bash
    ansible-playbook tachyondev-experiment.yml
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

Directory Structure
-------------------

- ``bin``: scripts that orchestrate the Experiment Master.
- ``experiments``: where you go to launch experiments. 
- ``images``: scripts for installing the systems using containers. 
- ``roles``: scripts (used by Ansible) that add services to nodes.
- ``test``: re-run all experiments.

Writing Experiments
-------------------

Each role has required variables that MUST be set.

lttng role
==========

- CONTAINER: which container to start LTTnG in (e.g., ceph)
- TRACEPOINT: which tracepoints to activate (e.g., mds:req*)

ceph role
=========

- STARTUP: which startup script to use to launch daemons (e.g., standalone.sh)

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

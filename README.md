============================================
Infra: a framework for deploying systems and running experiments
============================================

This is the SRL's infrastructure repository. 

Quickstart
==========

1. On all nodes, [install Docker](https://docs.docker.com/installation). For Ubuntu, you can use:

    ```bash
    cd bin
    ./bootstrap.sh
    ```

2. On this node, start an ``experiment master``:

    ```bash
     cd bin
     ./emaster.sh
     ```

3. Run an experiment:

    ```bash
    root@experiment_master# ansible-playbook tachyon.yml
    ```

Description
===========

The experiment master orchestrates the installation/deployment and runs experiments using Ansible. Nodes install packages using Docker images. When launching the experiment master, a Docker images with Ansible is pulled/installed and sets up passwordless login. To push the keys the script asks for a password.

Directory Structure
-------------------

- ``experiments``: where you go to launch experiments. The user should only have to cd to this directory.
- ``deploy``: scripts for deploying the systems and running experiments using Ansible.
- ``images``: scripts for installing the systems using containers. Stuff in here gets built into an image and automatically uploaded to the Docker Hub.
- ``bin``: scripts that orchestrate the Experiment Master.

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

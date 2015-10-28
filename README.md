============================================
Infra: a framework for deploying systems and running experiments
============================================

This is the SRL's infrastructure repository. 

Quickstart
==========

1. On all nodes, [install Docker](https://docs.docker.com/installation). For Ubuntu, you can use:

2. On this node, start an ``experiment master``:

    ```bash
     cd bin
     ./emaster.sh
     ```

3. Run an experiment:

    ```bash
    ansible-playbook zlog.yml
    ```

Description
===========

The experiment master orchestrates the installation/deployment and runs experiments using Ansible. Nodes install packages using Docker images. When launching the experiment master, a Docker images with Ansible is pulled/installed and sets up passwordless login. To push the keys the script asks for a password.

Each system has two roles, for example foo and foo-build. The foo-build role pulls the code, builds it, and packages it up for network transfer. The foo role pushes the code to the remote node and launches, unarchives it, and attaches a container to the code base. Then it starts the container and starts the daemons for the service in the container.

Directory Structure
-------------------

- ``experiments``: where you go to launch experiments. 
- ``deploy``: scripts for deploying the systems and running experiments using Ansible.
- ``images``: scripts for installing the systems using containers. 
- ``bin``: scripts that orchestrate the Experiment Master.
- ``roles``: scripts (used by Ansible) that add services to nodes.

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

============================================
Infra: a framework for running experiments
============================================

[![Build Status](https://travis-ci.org/systemslab/infra.svg?branch=master)](https://travis-ci.org/systemslab/infra)

This is the SRL's infrastructure repository for reproducibly running experiments.

Install
======

On all nodes, [install Docker](https://docs.docker.com/engine/installation/). On the head node, [install Ansible](http://docs.ansible.com/ansible/intro_installation.html).

Quickstart
==========

1. Pick an experiment:

   ```bash
   cd experiments/ceph-experiments/radosbench
   ```

2. Tell me about your cluster:

   ```bash
   cp hosts.template hosts
   vim hosts
   ```

3. Run the job:

    ```bash
     ansible-playbook experiment.yml
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

Additional Resources
====================

See the [docs](docs) directory for additional developer resources.

EOF

Infra: a framework for running experiments
============================================

[![Build Status](https://travis-ci.org/systemslab/infra.svg?branch=master)](https://travis-ci.org/systemslab/infra)

This is the SRL's infrastructure repository for reproducibly running experiments.

Install
-------

On all nodes:

1. Setup passwordless SSH and sudo
2. Install [Docker](https://docs.docker.com/engine/installation/)

Quickstart
----------

1. Start an experiment master and pick an experiment:

   ```bash
   $ bin/emaster.sh
   [EXPERIMENT_MASTER] cd ceph/template
   ```

2. Tell me about your cluster:

   ```bash
   [EXPERIMENT_MASTER] cp hosts.template hosts
   [EXPERIMENT_MASTER] vim hosts
   ```

3. Run the job:

    ```bash
    [EXPERIMENT_MASTER] ansible-playbook experiment.yml
     ```

Description
-----------

This repository has the infrastructure (code, scripts, etc.) for running experiments and graphing results. It deploys, measures, and tears down different systems. Experiments are standalone; they require no extra software or setup. The systems we support are in the [roles](roles) directory and the experiments we run are in the [experiments](experiments) directory. 

The experiment master runs experiments using Ansible. Nodes install packages using Docker images. Each system has two roles, for example `foo` and `foo-build`.

- `foo-build` builds code that is already sitting in a directory. We do not pull the code because some of the repositories we clone from are private and setting up the keys is a pain.
- `foo` pushes the code to the remote node and launchess it. It does this by attaching containers to the code and launching daemons.


Motivation
----------

- Reproducibility: exchanging code and starting the systems for another person
- Tuning and Benchmarking: running jobs overnight and fully utilizing the cluster
- Performance Bug Fixes: automatically test multiple code revisions
- Isolation: system libraries do not interfere with each other

Repository Structure
--------------------

- ``bin``: install and experiment master scripts.

- ``ci``: continuous integration test scripts.

- ``docs``: documentation.

- ``docker``: files for building the experiment master Docker image.

- ``experiments``: configuration files for running benchmarks.

- ``roles``: Ansible code for installing/deploying systems using Docker.



Additional Resources
--------------------

See the [docs](docs) directory for additional developer resources.

EOF

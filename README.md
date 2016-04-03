srl-roles: code for deploying experiments
============================================

[![Build Status](https://travis-ci.org/systemslab/srl-roles.svg?branch=master)](https://travis-ci.org/systemslab/srl-roles)

These are all the systems that the SRL uses in our experiments.

Install
-------

On all nodes:

1. Setup passwordless SSH and sudo
2. Install [Docker](https://docs.docker.com/engine/installation/)

Quickstart
----------

1. Start an experiment master:

   ```bash
   ./emaster.sh
   ```

2. Pick an experiment and configure it:

   ```bash
   [EXPERIMENT_MASTER] cd roles/ceph/test
   [EXPERIMENT_MASTER] cp hosts.template hosts
   ```

3. Run the job:

    ```bash
    [EXPERIMENT_MASTER] ansible-playbook experiment.yml
     ```

Description
-----------

This repository has the infrastructure (code, scripts, etc.) for running experiments and graphing results. It deploys, measures, and tears down different systems. Experiments are standalone; they require no extra software or setup. 


Motivation
----------

- Reproducibility: exchanging code and starting the systems for another person
- Tuning and Benchmarking: running jobs overnight and fully utilizing the cluster
- Performance Bug Fixes: automatically test multiple code revisions
- Isolation: system libraries do not interfere with each other

Additional Resources
--------------------

See the [docs](docs) directory for information on setting up experiments and for additional developer resources.

EOF

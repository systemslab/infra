============================================
Infra Design
============================================

Development
===========
The directory structure looks like this:

``infra``
- ``bin``: scripts that orchestrate the Experiment Master.
- ``docs``: documentation.
- ``modules``: extra Ansible modules.
- ``roles``: scripts for installing (Docker) and deploying (Ansible) services.
- ``test``: re-run all experiments.

Adding experiments
==================

To add a new experiment, you must add a role and an experiment specification.

Adding Roles
------------

A role is code that installs/deploys a system. To see an example, see the [Ceph role](roles/ceph/deploy/tasks/main.yml). If you look in a role directory, you will see two types of directories:

1. docker-* directories: contain Docker images with the packages and environment needed to run the system.

2. experiments directory: contains Ansible scripts for running experiments.

3. all other directories: contain Ansible scripts (``*.yml``) that either deploy or build the system.

Installing Roles
----------------

Sometimes we want our roles to be private. We have modularized infra so that you can drop your roles into the framework and still be able to deploy/build experiments. To do this, drop the role into the ``roles`` directory and then put an experiment yml file into ``experiments`` that uses that role.

EOF

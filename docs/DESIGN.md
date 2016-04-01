Infra Design
============

Experiment structure
--------------------

Each file in the ``experiment`` directory runs Ansible code:

- ``.ansible.cfg``: tells Ansible where the roles directory is and specifies how to use SSH.

- ``cleanup.yml``: cleans up after the experiment (e.g., removing containers, deleting directories, etc.)

- ``experiment.yml``: bash-like syntax for running the benchmark.

- ``hosts.template``: specifies the layout of the cluster, like which services are on which nodes.

- ``site``: tells Ansible where to look for roles. For every system in your experiment (e.g., Hadoop, Swift, etc.), you must have a ``site.yml`` file. 

To add a new experiment, you must add a ``role`` and an ``experiment`` configuration. 

Adding Experiments
--------------------------

1. Create a new directory:

    ```bash
    cd experiments
    mkdir my-benchmark
    ```

2. Copy the templates and sites for the systems you want to use:

   ```bash
   cp -r ../hadoop/template large-objects
   cp ../swift/template/site/site.yml large-objects/site/site.yml
   ```

3. Edit your experiment:
   ```bash
   vim experiment.yml
   ```

Adding Roles
------------

A role is code that installs/deploys a system. To see an example, see the [Swift role](../roles/swift). If you look in a role directory, you will see two types of directories:

1. docker- * directories: Dockerfile code for building the image. Docker images have all the packages and environment variables needed to run the system.

2. all other directories: Ansible scripts (``*.yml``) that either deploy or build the system.

Installing Roles
----------------

Sometimes we want our roles to be private. We have modularized infra so that you can drop your roles into the framework and still be able to deploy/build experiments. To do this, drop the role into the ``roles`` directory and then put an experiment yml file into ``experiments`` that uses that role.

EOF

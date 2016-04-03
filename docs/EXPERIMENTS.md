Experiments
==========

Each file in the ``experiment`` directory runs Ansible code:

- ``ansible.cfg``: tells Ansible where the roles directory is and specifies how to use SSH.

- ``cleanup.yml``: cleans up after the experiment (e.g., removing containers, deleting directories, etc.)

- ``experiment.yml``: bash-like syntax for running the benchmark.

- ``hosts.template``: specifies the layout of the cluster, like which services are on which nodes.

- ``site``: tells Ansible where to look for roles. For every system in your experiment (e.g., Hadoop, Swift, etc.), you must have a ``site.yml`` file. 

To add a new experiment, you must add a ``role`` and an ``experiment`` configuration. 

Adding Experiments
--------------------------

1. Create a new Git repository for your experiments:

2. Copy the templates and sites for the systems you want to use:

   ```bash
   cp -r srl-roles/hadoop/test <my_benchmark>/experiment1
   cp srl-roles/swift/test/site/site.yml <my_benchmark>/experiment1/site/swift.yml
   ```

3. Edit your experiment and setup your group variables:

   ```bash
   cd <my_benchmark>/experiment1
   vim experiment.yml
   vim group_vars/all
   ```

Adding Roles
------------

A role is code that installs/deploys a system. To see an example, see the [Swift role](../roles/swift). If you look in a role directory, you will see two types of directories:

1. dockerfiles: Dockerfile code for building the image. Docker images have all the packages and environment variables needed to run the system.

2. all other directories: Ansible scripts (``*.yml``) that either deploy or build the system. These are used in the ``site.yml`` files you setup above.

EOF

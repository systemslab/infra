============================================
Infra Documentaiton
============================================

Below are the different roles and their variables.

ceph
====

Deploy a container that runs Ceph.

options
-------

parameter | required | default |  comments
--------- | -------- | ------- | --------
container | no       | ceph    |  name of the container
sshd_port | no       | 2222    |  port* for SSH daemon inside the container
startup   | no       | small.sh |  script** for starting Ceph

Notes:

\* Make sure that you do not have two containers each trying to grab the same port... this prevents the SSH daemon from starting and the container immediately exits

\** All scripts are located in roles/files/ceph-scripts; a blank value does not start Ceph

ceph-build
====

Deploy a container that builds Ceph.

options
-------

parameter | required | default | comments
--------- | -------- | ------- | --------
commit    | no       | master  | SHA1 or reference (e.g., git branch) of the code
pkgs      | no       |         | which packages* to enable
git_url   | no       |         | repo location for the code
threads   | no       | 8       | number of threads to use when building

Notes:

\* You can figure these out by checking out the source code and running:
```bash
autogen.sh
./configure --help 
```

lua-rados-build
====

Deploy a container that builds the Lua-Rados bindings

options
-------

parameter | required | default | comments
--------- | -------- | ------- | --------
commit    | no       | master  | SHA1 or reference (e.g., git branch) of the code
pkgs      | no       |         | which packages* to enable
git_url   | no       |         | repo location for the code
threads   | no       | 8       | number of threads to use when building

mantle
======

Deploy a container that runs Mantle.

options
———

startup: s

subtleties: port number, recompiling or not?


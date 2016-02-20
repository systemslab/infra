===
Frequently Asked Questions
===

These aren't really "frequently asked"... it's just a list of stuff that has given us a major headache.

Questions and Answers
=====================

Here is a list of problems (and their solutions).

Q: The container fails to pull down Ubuntu repos and can't seem to reach the internet
--------------------------------------------------------------------------------------

This connectivity issue [1] is fixed with:

    ```bash
    sudo apt-get install bridge-utils
    pkill docker
    iptables -t nat -F
    ifconfig docker0 down
    brctl delbr docker0
    sudo service docker start
    ```

Q: On Centos6, I get: "NameError: global name 'DEFAULT_DOCKER_API_VERSION' is not defined"
------------------------------------------------------------------------------------------

Centos6 is not supported but a workaround [2] is to yum install python-docker-py.x86_64

Q: I get: "chpasswd: (user root) pam_chauthtok() failed, error: System error"
-----------------------------------------------------------------------------------------------

This is a kernel bug, according to [3]. Get out of the 3.13 kernel.

Q: Ceph daemons enter standby mode because they can't grab a resource in /var/lib/ceph
--------------------------------------------------------------------------------------

Sometimes docker gets hung up and won't handle the virtual volumes correctly. To fix this:

    ```bash
    sudo docker restart
    ```

Q: When building a docker image, the container can't reach the internet
---------------------------------------------------------------------------

Docker doesn't do well behind proxies -- you need to tell it who to ping:

    ```bash
     echo "DOCKER_OPTS=\"--dns 15.214.0.20\"" >> /etc/default/docker
     sudo service docker restart
    ```

References
==========
[1] http://serverfault.com/questions/642981/docker-containers-cant-resolve-dns-on-ubuntu-14-04-desktop-host
[2] https://github.com/ansible/ansible-modules-core/issues/1792
[3] https://github.com/docker/docker/issues/5704

EOF


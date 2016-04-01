Frequently Asked Questions
==========================

These are not really "frequently asked"... it is just a list of stuff that has given us a major headache.

###Q: The container fails to pull down Ubuntu repos and cannot seem to reach the internet

This connectivity issue [1] is fixed with:

```bash
sudo apt-get install bridge-utils
pkill docker
iptables -t nat -F
ifconfig docker0 down
brctl delbr docker0
sudo service docker start
```

###Q: On Centos6, I get: "NameError: global name 'DEFAULT_DOCKER_API_VERSION' is not defined"

Centos6 is not supported but a workaround [2] is to yum install python-docker-py.x86_64

###Q: I get: "chpasswd: (user root) pam_chauthtok() failed, error: System error"

This is a kernel bug, according to [3]. Get out of the 3.13 kernel.

###Q: Ceph daemons enter standby mode because they can't grab a resource in /var/lib/ceph

Sometimes docker gets hung up and won't handle the virtual volumes correctly. To fix this:

```bash
sudo docker restart
```

###Q: When building a docker image, the container can't reach the internet

Docker doesn't do well behind proxies -- you need to tell it who to ping:

```bash
 echo "DOCKER_OPTS=\"--dns 15.214.0.20\"" >> /etc/default/docker
 sudo service docker restart
    ```

###Q: When Ansible pulls an image, I get: fatal: [localhost]: FAILED! => {"failed": true, "msg": "module (docker) is missing interpreter line"}

Directory location matters -- make sure to be in the experiment working directory before executing:

```bash
cd roles/hadoop/experiments
ansible-playbook compile.yml
```

###Q: Ansible cannot gather facts, failing on "/bin/lsblk -ln --output UUID /dev/sda1"

Containers running VMs will hang if there are multiple accesses to the block device. This is a known issue that should be solved in Ansible 2.1, where we can specify which facts to gather. For now, run without the emaster/eslave if you are in a VM.

###Q: Docker kills ssh:

We cannot run Docker inside a container -- the following kills all services (Docker, ssh, etc.)

```bash
docker stop c0 c1; docker rm d0 c1
```

###Q: It appears SSH hangs

This could be because: (1) it is waiting for a password, (2) you have strict host key checking on, or (3) Travis has slow SSH logins. This can be resolved with `--become`, `host_key_checking=False`, and `connection=local`/`connection=ssh`, respectively.

References
----------
[1] http://serverfault.com/questions/642981/docker-containers-cant-resolve-dns-on-ubuntu-14-04-desktop-host

[2] https://github.com/ansible/ansible-modules-core/issues/1792

[3] https://github.com/docker/docker/issues/5704


Advantages of Hathisar
- incompatible docker, docker-py, CentoOS versions
- no need to install ansible on the host
- deleting files can use the ANsible modules instead of:
  ```bash
  docker exec ceph-mon rm -r /var/lib/ceph/osd
  ```
EOF


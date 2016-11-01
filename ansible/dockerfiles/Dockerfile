FROM tutum/ubuntu:trusty

MAINTAINER Michael Sevilla <mikesevilla3@gmail.com>

RUN echo "===> Install the basics..." && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    echo "===> Install Ansible..."  && \
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | tee /etc/apt/sources.list.d/ansible.list && \
    echo "deb-src http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/ansible.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7BB9C367 && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -yq --force-yes ansible && \
    echo "===> Cleanup apt-get..." && \
    sudo apt-get clean && sudo rm -rf \
      /var/lib/apt/lists/* /etc/apt/sources.list.d/ansible.list \
      tmp/* /var/tmp/* 

ENV "TERM=xterm-256color"
ENTRYPOINT ["/usr/bin/ansible-playbook"]

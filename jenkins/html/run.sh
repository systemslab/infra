#!/bin/bash
ansible -o all -a "/bin/bash -c \"
  docker ps -a | grep -v NAMES | awk '{print \$(NF)}'; 
  echo ' | '; 
  lsblk | grep disk | awk '{print \$1}' 
  \"" > status.txt
echo `date +"%A %B %d %r"` > lastcheck.txt

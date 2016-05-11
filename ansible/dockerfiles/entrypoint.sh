#!/bin/bash

# customize the prompt
echo "export PS1=[ANSIBLE@$HOSTNAME]\ " >> /root/.bashrc
/bin/bash

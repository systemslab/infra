#!/bin/bash

if [ -z "$XAUTH" ]; then
  echo "=> Didn't find any screens so you can't use the graphers"
else
  xauth add $XAUTH >> /dev/null 2>&1
fi

# customize the prompt
echo "export PS1=[EXPERIMENT_MASTER]\ " >> /root/.bashrc
/bin/bash

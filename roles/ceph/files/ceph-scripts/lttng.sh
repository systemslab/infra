#!/bin/bash

lttng destroy
lttng create 
lttng enable-event -u --tracepoint "mds:req*" -c 0
lttng start


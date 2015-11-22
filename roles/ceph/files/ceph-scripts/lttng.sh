#!/bin/bash

lttng destroy
lttng create -o /lttng
lttng enable-event -u --tracepoint "mds:req*" -c 0
lttng start


Launches a graphite and its webui in a container so we can monitor the cluster.

This should be used as a tool in the [srl-roles](https://github.com/systemslab/srl-roles) experiment orchestration framework.

===================================================
Quickstart
===================================================

Launch graphite in the container and tell it what to monitor:

```bash
docker run \
  --name=graphite \
  --net=host \
  michaelsevilla/graphite
```

You can fill in STORAGE_SCHEMAS, CARBON, and DASHBOARD environment variables to
append values to the conf files.

EOF

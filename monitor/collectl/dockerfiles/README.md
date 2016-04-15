Launches a collectl in a container so we can monitor the current node. Collectl can gather CPU, Network, and IO usage.

This should be used as a tool in the [srl-roles](https://github.com/systemslab/srl-roles) experiment orchestration framework.

===================================================
Quickstart
===================================================

Launch collectl in the container and tell it what to monitor:

```bash
docker run \
  --name=collectl \
  --net=host \
  -v /tmp/collectl:/tmp/collectl \
  -e COLLECTL_ARGS="-o z -P -i 10 -f /tmp/collectl" \
  michaelsevilla/collectl
```

EOF

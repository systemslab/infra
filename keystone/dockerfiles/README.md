# docker-keystone
Wraps a given Keystone in a container. Pretty basic stuff...

===================================================
Quickstart
===================================================

To launch a node with Kesytone installed:

```bash
docker run -d \
  --name keystone \
  --net=host 
   michaelsevilla/keystone
```

There are some environement variables you can set -- checkout the entrypoint to see what they are.

EOF

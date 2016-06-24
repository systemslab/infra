# Quickstart

```bash
docker run -dt \
  --name cloudfuse \
  --net host \
  --privileged \
  -v /dev/fuse:/dev/fuse \
  -e USERNAME=<USER> \
  -e TENANT=<TENANT> \
  -e PASSWORD=<PASSWORD> \
  -e AUTHURL=http://<KEYSTONE IP>:5000/v2.0 \
  michaelsevilla/cloudfuse
```

This is part of a larger deploy framework called [infra](https://github.com/systemslab/infra.git).

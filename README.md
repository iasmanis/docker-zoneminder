# zmdockerfiles

## Usage

**Note:** Detailed usage instructions for the development and release Dockerfiles are contained within each Dockerfile.

The Docker images are available from the Docker Hub e.g.

```bash
docker run -d -t -p 1080:80 \
    -e TZ='Europe/London' \
    -v ~/zoneminder/events:/var/cache/zoneminder/events \
    -v ~/zoneminder/images:/var/cache/zoneminder/images \
    -v ~/zoneminder/mysql:/var/lib/mysql \
    -v ~/zoneminder/logs:/var/log/zm \
    --shm-size="512m" \
    --name zoneminder \
    ingemars/zoneminder:ubuntu18.04-<tag>
```

```bash
docker service create \
    --name zoneminder \
    --limit-cpu=1 \
    --limit-memory=2400Mb \
    -e TZ='Europe/Rome' \
    -e ZM_DB_USER='myuser' \
    -e ZM_DB_PASS='mypass' \
    -e ZM_DB_NAME='zm' \
    -e ZM_DB_HOST='mysql' \
    --mount "type=bind,source=/opt/shared/zoneminder/config,target=/etc/zm/conf.d" \
    --mount "type=bind,source=/opt/shared/zoneminder/logs,target=/var/log/zm" \
    --mount "type=bind,source=/var/lib/zoneminder/events,target=/var/cache/zoneminder/events" \
    --mount "type=tmpfs,target=/dev/shm,tmpfs-size=1936870912,tmpfs-mode=0777" \
    ingemars/zoneminder:ubuntu18.04-<tag>
```

Once the container is running you will need to browse to http://hostname:port/zm to access the Zoneminder interface.

## Contributions

Contributions are welcome, but please follow instructions under each subfolder:

- [buildsystem](https://github.com/ZoneMinder/zmdockerfiles/tree/master/buildsystem) - These build zoneminder into packages
- [development](https://github.com/ZoneMinder/zmdockerfiles/tree/master/development) - These run the latest ZoneMinder code.
- [release](https://github.com/ZoneMinder/zmdockerfiles/tree/master/release) - These run the latest ZoneMinder release.

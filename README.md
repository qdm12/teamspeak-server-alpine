# Teamspeak 3 Server (based on Alpine and sgerrand/alpine-pkg-glibc)

Docker container running a lightweight Teamspeak 3.1.1 server

[![Docker Teamspeak 3.1.1](https://github.com/qdm12/teamspeak-server-alpine/raw/master/readme/title.png)](https://hub.docker.com/r/qmcgaw/teamspeak3-alpine)

[![Build Status](https://travis-ci.org/qdm12/teamspeak-server-alpine.svg?branch=master)](https://travis-ci.org/qdm12/teamspeak-server-alpine)
[![Docker Build Status](https://img.shields.io/docker/build/qmcgaw/teamspeak3-alpine.svg)](https://hub.docker.com/r/qmcgaw/teamspeak3-alpine)

[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/teamspeak-server-alpine.svg)](https://github.com/qdm12/teamspeak-server-alpine/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/teamspeak-server-alpine.svg)](https://github.com/qdm12/teamspeak-server-alpine/issues)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/teamspeak-server-alpine.svg)](https://github.com/qdm12/teamspeak-server-alpine/issues)

[![Docker Pulls](https://img.shields.io/docker/pulls/qmcgaw/teamspeak3-alpine.svg)](https://hub.docker.com/r/qmcgaw/teamspeak3-alpine)
[![Docker Stars](https://img.shields.io/docker/stars/qmcgaw/teamspeak3-alpine.svg)](https://hub.docker.com/r/qmcgaw/teamspeak3-alpine)
[![Docker Automated](https://img.shields.io/docker/automated/qmcgaw/teamspeak3-alpine.svg)](https://hub.docker.com/r/qmcgaw/teamspeak3-alpine)

[![](https://images.microbadger.com/badges/image/qmcgaw/teamspeak3-alpine.svg)](https://microbadger.com/images/qmcgaw/teamspeak3-alpine)
[![](https://images.microbadger.com/badges/version/qmcgaw/teamspeak3-alpine.svg)](https://microbadger.com/images/qmcgaw/teamspeak3-alpine)

| Download size | Image size | RAM usage | CPU usage |
| --- | --- | --- | --- |
| ?MB | 22.6MB | ?MB | ? |

It is based on:
- [Alpine 3.7](https://alpinelinux.org)
- [alpine-pkg-glibc](https://github.com/sgerrand/alpine-pkg-glibc)
- CA-Certificates
- Teamspeak 3.1.1 amd64

## Running it

1. Create a directory `logs` in `/yourpath` with (change `yourpath`):

    ```bash
    mkdir -p /yourpath/logs
    ```

1. Launch the server:

    ```bash
    docker run -it --rm -p 9987:9987/udp -p 10011:10011/tcp -p 30033:30033/tcp -v /yourpath:/data qmcgaw/teamspeak3-alpine
    ```

    You can also download  and use [*docker-compose.yml*](https://github.com/qdm12/teamspeak-server-alpine/blob/master/docker-compose.yml)

## Connect to the server

TODO

### Test on your local network

### Over the Internet

1. Open the ports on your router

1. Enter your pub Ip or domain

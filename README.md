# Teamspeak 3.13 Server on Alpine

23MB docker container running a Teamspeak 3.13.6 server

[![Docker Teamspeak 3.13](https://github.com/qdm12/teamspeak-server-alpine/raw/master/readme/title.png)](https://hub.docker.com/r/qmcgaw/teamspeak3-alpine)

[![Build status](https://github.com/qdm12/teamspeak-server-alpine/actions/workflows/ci.yml/badge.svg)](https://github.com/qdm12/teamspeak-server-alpine/actions/workflows/ci.yml)

[![dockeri.co](https://dockeri.co/image/qmcgaw/teamspeak3-alpine)](https://hub.docker.com/r/qmcgaw/teamspeak3-alpine)

![Last release](https://img.shields.io/github/release/qdm12/teamspeak-server-alpine?label=Last%20release)
![Last Docker tag](https://img.shields.io/docker/v/qmcgaw/teamspeak3-alpine?sort=semver&label=Last%20Docker%20tag)
[![Last release size](https://img.shields.io/docker/image-size/qmcgaw/teamspeak3-alpine?sort=semver&label=Last%20released%20image)](https://hub.docker.com/r/qmcgaw/teamspeak3-alpine/tags?page=1&ordering=last_updated)
![GitHub last release date](https://img.shields.io/github/release-date/qdm12/teamspeak-server-alpine?label=Last%20release%20date)
![Commits since release](https://img.shields.io/github/commits-since/qdm12/teamspeak-server-alpine/latest?sort=semver)

[![Latest size](https://img.shields.io/docker/image-size/qmcgaw/teamspeak3-alpine/latest?label=Latest%20image)](https://hub.docker.com/r/qmcgaw/teamspeak3-alpine/tags)

[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/teamspeak-server-alpine.svg)](https://github.com/qdm12/teamspeak-server-alpine/commits/master)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/teamspeak-server-alpine.svg)](https://github.com/qdm12/teamspeak-server-alpine/graphs/contributors)
[![GitHub closed PRs](https://img.shields.io/github/issues-pr-closed/qdm12/teamspeak-server-alpine.svg)](https://github.com/qdm12/teamspeak-server-alpine/pulls?q=is%3Apr+is%3Aclosed)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/teamspeak-server-alpine.svg)](https://github.com/qdm12/teamspeak-server-alpine/issues)
[![GitHub closed issues](https://img.shields.io/github/issues-closed/qdm12/teamspeak-server-alpine.svg)](https://github.com/qdm12/teamspeak-server-alpine/issues?q=is%3Aissue+is%3Aclosed)

[![MIT](https://img.shields.io/github/license/qdm12/teamspeak-server-alpine)](https://github.com/qdm12/teamspeak-server-alpine/master/LICENSE)
![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=teamspeak-server-alpine.readme)

It is based on:

- [Alpine 3.14](https://alpinelinux.org)
- [libstdc++](https://pkgs.alpinelinux.org/package/3.14/main/x86_64/libstdc++)
- [CA-Certificates](https://pkgs.alpinelinux.org/package/3.14/main/x86_64/ca-certificates)
- [Teamspeak 3.13.6 alpine](https://www.teamspeak.com/en/downloads/#server)

## Features

- Low size
- Regular healthcheck
- Runs without root
- Minimalist (trimmed out mariadb option)
- *Only compatible with amd64 because Teamspeak is only built for amd64*

## Setup

1. (If you want persistence) Create two directories `./data` and `./logs` and apply the correct ownership and permissions with:

    ```bash
    mkdir -p data logs
    chown 1000 data logs
    chmod 700 data logs
    ```

    Note that you can set `chown` to another UID (i.e. `8000`) provided you run the container with `--user=8000`.

1. Use the following command:

    ```bash
    docker run -d -p 9987:9987/udp -p 10011:10011/tcp -p 30033:30033/tcp \
    -e TS3SERVER_LICENSE=accept \
    -v $(pwd)/data:/teamspeak/data -v $(pwd)/logs:/teamspeak/logs \
    qmcgaw/teamspeak3-alpine
    ```

    - The UDP port 9987 is used for the main voice server
    - The TCP port 10011 is used for file transfers
    - The TCP port 30033 is used for remote management
    - The `data` directory contains the database `ts3server.sqlitedb`, and IP blacklist and whitelist `query_ip_blacklist.txt` and `query_ip_whitelist.txt`
    - The `logs` directory contains text log files

    or use [docker-compose.yml](https://github.com/qdm12/teamspeak-server-alpine/blob/master/docker-compose.yml) with:

    ```bash
    docker-compose up -d
    ```

**On the first run**, if your bind mounts contain no files, you will have likely to run on your host:

```sh
chmod 700 data/ts3server.sqlitedb
```

## Connect to the server

1. Download a client on your machine from [https://www.teamspeak.com/downloads.html#client](https://www.teamspeak.com/downloads.html#client)
1. Install it and launch it
1. On your Docker host, enter

    ```bash
    ip address
    ```

    You can find your host LAN IP address to use to connect to the Teamspeak server.
1. On your Docker host, enter the following:

    ```bash
    docker logs teamspeak
    ```

    You should see a few lines similar to:

    ```sh
    2018-04-16 02:54:18.228719|WARNING |VirtualServer |1  |--------------------------------------------------------
    2018-04-16 02:54:18.228789|WARNING |VirtualServer |1  |ServerAdmin privilege key created, please use the line below
    2018-04-16 02:54:18.228825|WARNING |VirtualServer |1  |token=u3bJyR+ZcUJRxgJ+CKsJmQgygR+gMuPMz7qkyaQa
    2018-04-16 02:54:18.228855|WARNING |VirtualServer |1  |--------------------------------------------------------
    ```

    Copy the token `u3bJyR+ZcUJRxgJ+CKsJmQgygR+gMuPMz7qkyaQa` to identify as the administrator using the Teamspeak client.
1. In your Teamspeak client, follow the instructions as shown on the following pictures:

    ![Client step 1](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client1.png?raw=true)

    ![Client step 2](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client2.png?raw=true)

    Enter the Docker host LAN IP address as well as your admin token you previously copied.

    ![Client step 3](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client3.png?raw=true)

    You are now connected as administrator to your Teamspeak server

    ![Client step 4](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client4.png?raw=true)

    You might want now to:
    - Set encrypted voice communication globally on (right click on server -> Edit virtual server -> Security tab -> Channel voice encryption (bottom) )
    - Set a password
    - Set permissions
    - Set up and modify channels
1. Find your router LAN IP address and access it with your web browser, usually at [http://192.168.1.1](http://192.168.1.1).
1. Forward the following ports on your router:
    - TCP 10011 -> 10011 for your Docker host
    - TCP 30033 -> 30033 for your Docker host
    - UDP 9987 -> 9987 for your Docker host
1. On your Docker host, enter

    ```bash
    wget -qO- https://ipinfo/ip
    ```

    This is the public IP address of your Docker host and therefore of your Teamspeak server for people outside your network
1. In your Teamspeak client, follow the instructions as shown on the following pictures:

    ![Client step 5](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client1.png?raw=true)

    ![Client step 6](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client2.png?raw=true)

    Enter the public IP address previously found, or your domain name if you have one.

    ![Client step 7](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client5.png?raw=true)

    You should now be connected to your Teamspeak server as before. Note that your credentials data is stored on your computer so it won't ask you for the admin token or a password.
1. To share it with other people, give them your public IP address or domain name, and the password to access the server

## Expired license

If you get a message similar to:

```log
The default license has expired. Please use the latest server version
```

Then you can try first pulling the lates image `docker pull qmcgaw/teamspeak3-alpine` or build it yourself.

To build yourself:

1. Check out which server version you want from [files.teamspeak-services.com/releases/server/](https://files.teamspeak-services.com/releases/server/)
1. Make sure you have `git` installed
1. Run this build command (which is also quick):

    ```sh
    docker build --build-arg TEAMSPEAK_VERSION=3.13.6 \
    -t qmcgaw/teamspeak3-alpine \
    https://github.com/qdm12/teamspeak-server-alpine.git
    ```

    You can also specify the build argument `--build-arg ALPINE_VERSION=3.14` if you want.

## TODOs

- [ ] Env variables
- [ ] Ban malicious IPs
- [ ] Scratch

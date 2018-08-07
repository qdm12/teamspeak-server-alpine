# Teamspeak 3 Server (based on Alpine and sgerrand/alpine-pkg-glibc)

Docker container running a lightweight Teamspeak 3.3.0 server

[![Docker Teamspeak 3.3.0](https://github.com/qdm12/teamspeak-server-alpine/raw/master/readme/title.png)](https://hub.docker.com/r/qmcgaw/teamspeak3-alpine)

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
| 11.4MB | 22.6MB | 24.1MB | Very Low to Low |

It is based on:
- [Alpine 3.8](https://alpinelinux.org)
- [**alpine-pkg-glibc**](https://github.com/sgerrand/alpine-pkg-glibc)
- [CA-Certificates](https://pkgs.alpinelinux.org/package/edge/main/x86_64/ca-certificates)
- [Teamspeak 3.3.3 amd64](https://www.teamspeak.com/en/downloads.html#server)

## Running it

1. Launch the server (change `yourpath` and `yourpath2`):

    ```bash
    docker run -it --rm -p 9987:9987/udp -p 10011:10011/tcp -p 30033:30033/tcp \
    -v /yourpath:/data -v /yourpath2:/teamspeak/logs qmcgaw/teamspeak3-alpine
    ```

    You can also download, edit and use [*docker-compose.yml*](https://github.com/qdm12/teamspeak-server-alpine/blob/master/docker-compose.yml)

## Connect to the server

1. Download a client on your machine from [https://www.teamspeak.com/downloads.html#client](https://www.teamspeak.com/downloads.html#client)
1. Install it and launch it
1. On your Docker host, enter
    
    ```bash
    ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' '  -f 1
    ```
    
    This is the LAN IP address of your Docker host and therefore of your Teamspeak server (in your LAN)

1. On your Docker host, enter the following:
    
    ```bash
    docker logs teamspeak
    ```
    
    You should see a few lines similar to:
    
    ```
    2018-04-16 02:54:18.228719|WARNING |VirtualServer |1  |--------------------------------------------------------
    2018-04-16 02:54:18.228789|WARNING |VirtualServer |1  |ServerAdmin privilege key created, please use the line below
    2018-04-16 02:54:18.228825|WARNING |VirtualServer |1  |token=u3bJyR+ZcUJRxgJ+CKsJmQgygR+gMuPMz7qkyaQa
    2018-04-16 02:54:18.228855|WARNING |VirtualServer |1  |--------------------------------------------------------
    ```
    
    Copy the token `u3bJyR+ZcUJRxgJ+CKsJmQgygR+gMuPMz7qkyaQa` to identify as the administrator using the Teamspeak client.

1. In your Teamspeak client, follow the instructions as shown on the following pictures:

    ![](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client1.png?raw=true)

    ![](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client2.png?raw=true)

    Enter the Docker host LAN IP address as well as your admin token you previously copied.

    ![](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client3.png?raw=true)

    You are now connected as administrator to your Teamspeak server

    ![](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client4.png?raw=true)

    You might want now to:
    - Set encrypted voice communication globally on (right click on server -> Edit virtual server -> Security tab -> Channel voice encryption (bottom) )
    - Set a password
    - Set permissions
    - Set up and modify channels

1. On your Docker host, enter
    
    ```bash
    netstat -nr | awk '$1 == "0.0.0.0"{print$2}'
    ```
    
    This is the LAN IP address of your router. Now access it in your web browser (usually [http://192.168.1.1](http://192.168.1.1)).

1. Forward the following ports on your router:
    - TCP 10011 -> 10011 for your Docker host
    - TCP 30033 -> 30033 for your Docker host
    - UDP 9987 -> 9987 for your Docker host

1. On your Docker host, enter
    
    ```bash
    wget -qO- https://api.ipify.org
    ```
    
    This is the public IP address of your Docker host and therefore of your Teamspeak server for people outside your network

1. In your Teamspeak client, follow the instructions as shown on the following pictures:

    ![](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client1.png?raw=true)

    ![](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client2.png?raw=true)

    Enter the public IP address previously found, or your domain name if you have one.

    ![](https://github.com/qdm12/teamspeak-server-alpine/blob/master/readme/client5.png?raw=true)

    You should now be connected to your Teamspeak server as before. Note that your credentials data is 
    stored on your computer so it won't ask you for the admin token or a password.
    
1. To share it with other people, give them your public IP address or domain name, and the password to access the server

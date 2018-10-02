FROM alpine:3.8
LABEL maintainer="quentin.mcgaw@gmail.com" \
      description="Lightweight TeamSpeak 3.4.0 server (Alpine, glibc)" \
      download="11.4MB" \
      size="22.6MB" \
      ram="29MB" \
      cpu_usage="Very Low to Low" \
      github="https://github.com/qdm12/teamspeak-docker"
ENV VERSION=3.4.0 \
    GLIBC_VERSION=2.28-r0 \
	SHA256=7d6ec8e97d4a9e9913a7e01f2e7f5f9fddfdc41b11e668d013a0f4b574d1918b
RUN apk add -q --progress --no-cache --update wget ca-certificates && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/unreleased/glibc-$GLIBC_VERSION.apk \
            https://github.com/sgerrand/alpine-pkg-glibc/releases/download/unreleased/glibc-bin-$GLIBC_VERSION.apk \
            https://github.com/sgerrand/alpine-pkg-glibc/releases/download/unreleased/glibc-i18n-$GLIBC_VERSION.apk && \
    apk add -q --progress --no-cache glibc-$GLIBC_VERSION.apk glibc-bin-$GLIBC_VERSION.apk glibc-i18n-$GLIBC_VERSION.apk && \
    rm /etc/apk/keys/sgerrand.rsa.pub glibc-*.apk && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 en-US.UTF-8 || true && \
    export LANG=en-US.UTF-8 && \
    apk del -q --progress --purge glibc-i18n glibc-bin && \
    mkdir -p /teamspeak/logs && \
    cd /teamspeak && \
    wget -q -O teamspeak.tar.bz2 http://dl.4players.de/ts/releases/$VERSION/teamspeak3-server_linux_amd64-$VERSION.tar.bz2 && \
    apk del -q --progress --purge wget && \
    [[ $(sha256sum teamspeak.tar.bz2 | cut -d" " -f 0) == $SHA256 ]] || (echo "Checksum of Teamspeak download failed!"; exit 1;) && \
    tar xf teamspeak.tar.bz2 --strip-components=1 && \
    touch .ts3server_license_accepted && \
    rm -rf teamspeak.tar.bz2 CHANGELOG LICENSE libts3db_mariadb.so doc redist serverquerydocs tsdns *.sh && \
    mkdir -p /data && \
    touch /data/ts3server.sqlitedb /data/query_ip_blacklist.txt /data/query_ip_whitelist.txt && \
    rm -rf /var/cache/apk/*
VOLUME /data /teamspeak/logs
RUN ln -s /data/ts3server.sqlitedb /teamspeak/ts3server.sqlitedb && \
    ln -s /data/query_ip_blacklist.txt /teamspeak/query_ip_blacklist.txt && \
    ln -s /data/query_ip_whitelist.txt /teamspeak/query_ip_whitelist.txt
ENV LD_LIBRARY_PATH=/teamspeak
EXPOSE 9987/udp 10011/tcp 30033/tcp
WORKDIR /teamspeak
ENTRYPOINT ./ts3server
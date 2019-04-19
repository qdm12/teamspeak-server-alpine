ARG ALPINE_VERSION=3.9

FROM alpine:${ALPINE_VERSION}
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=3.7.1
ARG SHA256=c82eebbe5dca9f33c8e52b0526fb92613f975c73463687e1561eefb79c0e5a69
LABEL org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="quentin.mcgaw@gmail.com" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/qdm12/teamspeak-server-alpine" \
      org.label-schema.url="https://github.com/qdm12/teamspeak-server-alpine" \
      org.label-schema.vcs-description="Light 19MB container running a Teamspeak 3 server" \
      org.label-schema.vcs-usage="https://github.com/qdm12/teamspeak-server-alpine/blob/master/README.md#setup" \
      org.label-schema.docker.cmd="docker run -d -p 9987:9987/udp -p 10011:10011/tcp -p 30033:30033/tcp -v $(pwd)/data:/teamspeak/data -v $(pwd)/logs:/teamspeak/logs qmcgaw/teamspeak3-alpine license_accepted=1" \
      org.label-schema.docker.cmd.devel="docker run -it --rm -p 9987:9987/udp qmcgaw/teamspeak3-alpine license_accepted=1" \
      org.label-schema.docker.params="" \
      org.label-schema.version="$VERSION" \
      image-size="21.3MB" \
      ram-usage="15MB" \
      cpu-usage="Low"
EXPOSE 9987/udp 10011/tcp 30033/tcp
COPY entrypoint.sh /teamspeak/entrypoint.sh
RUN apk --update --no-cache --progress -q add ca-certificates libstdc++ && \
    cd teamspeak && \
    wget -O teamspeak.tar.bz2 http://dl.4players.de/ts/releases/$VERSION/teamspeak3-server_linux_alpine-$VERSION.tar.bz2 && \
    echo "${SHA256}  teamspeak.tar.bz2" | sha256sum -c - && \
    tar xf teamspeak.tar.bz2 --strip-components=1 && \
    mkdir -p logs data lib && \
    mv *.so lib && \
    rm -r teamspeak.tar.bz2 LICENSE* CHANGELOG doc serverquerydocs tsdns redist && \
    touch data/ts3server.sqlitedb data/query_ip_blacklist.txt data/query_ip_whitelist.txt && \
    chown -R 1000 . && \
    chmod -R 400 * && \
    chmod -R 500 ts3server entrypoint.sh lib sql && \
    chmod 700 data data/ts3server.sqlitedb && \
    chmod 400 data/query* && \
    chmod 300 logs && \
    rm -rf /var/cache/apk/*
USER 1000
HEALTHCHECK --interval=120s --timeout=2s --start-period=15s --retries=1 \
        CMD [ "$(wget -qO- localhost:30033 2>&1)" = "wget: error getting response: Connection reset by peer" ] || exit 1
ENTRYPOINT ["/teamspeak/entrypoint.sh"]
CMD ["license_accepted=0"]

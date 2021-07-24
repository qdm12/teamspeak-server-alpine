ARG ALPINE_VERSION=3.14

FROM alpine:${ALPINE_VERSION}
ARG CREATED
ARG VERSION
ARG COMMIT
ARG TEAMSPEAK_VERSION=3.13.6
LABEL \
    org.opencontainers.image.authors="quentin.mcgaw@gmail.com" \
    org.opencontainers.image.created=$CREATED \
    org.opencontainers.image.version="$VERSION" \
    org.opencontainers.image.revision=$COMMIT \
    org.opencontainers.image.url="https://github.com/qdm12/teamspeak-server-alpine" \
    org.opencontainers.image.documentation="https://github.com/qdm12/teamspeak-server-alpine/blob/master/README.md" \
    org.opencontainers.image.source="https://github.com/qdm12/teamspeak-server-alpine" \
    org.opencontainers.image.title="Teamspeak 3 Server" \
    org.opencontainers.image.description="Light 23MB container running a Teamspeak 3 server"
EXPOSE 9987/udp 10011/tcp 30033/tcp
WORKDIR /teamspeak
RUN apk --update --no-cache --progress -q add ca-certificates wget libstdc++ && \
    wget -qO teamspeak.tar.bz2 https://files.teamspeak-services.com/releases/server/$TEAMSPEAK_VERSION/teamspeak3-server_linux_alpine-$TEAMSPEAK_VERSION.tar.bz2 && \
    apk del wget && \
    tar xf teamspeak.tar.bz2 --strip-components=1 && \
    mkdir -p logs data lib && \
    mv *.so lib && \
    rm -r teamspeak.tar.bz2 LICENSE* CHANGELOG doc serverquerydocs tsdns redist && \
    touch data/ts3server.sqlitedb data/query_ip_blacklist.txt data/query_ip_whitelist.txt && \
    chown -R 1000 . && \
    chmod -R 400 * && \
    chmod -R 500 ts3server lib sql && \
    chmod 700 data data/ts3server.sqlitedb && \
    chmod 400 data/query* && \
    chmod 300 logs && \
    rm -rf /var/cache/apk/*
HEALTHCHECK --interval=120s --timeout=2s --start-period=15s --retries=1 \
    CMD [ "$(wget -qO- localhost:30033 2>&1)" = "wget: error getting response: Connection reset by peer" ] || exit 1
ENTRYPOINT ["/teamspeak/entrypoint.sh"]
ENV TS3SERVER_LICENSE=
COPY --chown=1000 entrypoint.sh entrypoint.sh
RUN chmod 500 entrypoint.sh
USER 1000

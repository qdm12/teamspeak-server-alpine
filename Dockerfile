ARG BASE_IMAGE=alpine
ARG ALPINE_VERSION=3.10

FROM ${BASE_IMAGE}:${ALPINE_VERSION}
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=3.9.1
ARG SHA256=cb612c26ee18fa0027119056f656ce449caf799f02c0f1864a14b68ea25ed239
LABEL \
    org.opencontainers.image.authors="quentin.mcgaw@gmail.com" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.version="$VERSION" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.url="https://github.com/qdm12/teamspeak-server-alpine" \
    org.opencontainers.image.documentation="https://github.com/qdm12/teamspeak-server-alpine/blob/master/README.md" \
    org.opencontainers.image.source="https://github.com/qdm12/teamspeak-server-alpine" \
    org.opencontainers.image.title="Teamspeak 3 Server" \
    org.opencontainers.image.description="Light 19MB container running a Teamspeak 3 server" \
    image-size="21.6MB" \
    ram-usage="15MB" \
    cpu-usage="Low"
EXPOSE 9987/udp 10011/tcp 30033/tcp
WORKDIR /teamspeak
RUN apk --update --no-cache --progress -q add ca-certificates libstdc++ && \
    wget -O teamspeak.tar.bz2 https://files.teamspeak-services.com/releases/server/$VERSION/teamspeak3-server_linux_alpine-$VERSION.tar.bz2 2>&1 && \
    echo "${SHA256}  teamspeak.tar.bz2" | sha256sum -c - && \
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
CMD ["license_accepted=0"]
COPY --chown=1000 entrypoint.sh entrypoint.sh
USER 1000


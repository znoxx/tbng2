FROM debian:stable-slim


EXPOSE 9040
EXPOSE 9050
EXPOSE 9053/udp

RUN apt-get update && apt-get install -y tor curl tor-geoipdb obfs4proxy ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/torconf && chown -R debian-tor /opt/torconf

USER debian-tor

VOLUME /opt/torconf

ENTRYPOINT ["/usr/sbin/tor", "-f","/opt/torconf/torrc"]


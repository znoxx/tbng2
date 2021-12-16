FROM debian:stable-slim


EXPOSE 9040
EXPOSE 9050
EXPOSE 9053/udp

RUN apt-get update && apt-get install -y tor curl tor-geoipdb obfs4proxy ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN groupadd -r tor-tbng && useradd -r -g tor-tbng tor-tbng && mkdir -p /opt/torconf && chown -R tor-tbng /opt/torconf && \
    mkdir /home/tor-tbng && chown -R tor-tbng /home/tor-tbng

USER tor-tbng

VOLUME /opt/torconf

ENTRYPOINT ["/usr/sbin/tor", "-f","/opt/torconf/torrc"]


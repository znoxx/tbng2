FROM tbng-common


EXPOSE 9040
EXPOSE 9050
EXPOSE 9053/udp

RUN apt-get update && apt-get install --no-install-recommends -y \
    netbase psmisc \
    tor curl tor-geoipdb obfs4proxy && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/torconf && chown -R debian-tor /opt/torconf

USER debian-tor

VOLUME ["/opt/torconf","/var/lib/tor"]

ENTRYPOINT ["/usr/sbin/tor", "-f","/opt/torconf/torrc"]


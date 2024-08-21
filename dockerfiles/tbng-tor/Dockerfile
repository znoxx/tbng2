FROM tbng-common


EXPOSE 9040
EXPOSE 9050
EXPOSE 9053/udp

ADD tor.list /etc/apt/sources.list.d/
RUN wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null
RUN apt-get update && apt-get install --no-install-recommends -y deb.torproject.org-keyring

RUN apt-get install --no-install-recommends -y \
    netbase psmisc \
    tor curl tor-geoipdb obfs4proxy && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/torconf && chown -R debian-tor /opt/torconf

USER debian-tor

VOLUME ["/opt/torconf","/var/lib/tor"]

ENTRYPOINT ["/usr/sbin/tor", "-f","/opt/torconf/torrc"]


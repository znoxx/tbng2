FROM tbng-common

RUN apt-get update && apt-get install --no-install-recommends -y supervisor bash hostapd iptables isc-dhcp-server iproute2 iw && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /opt/ap
RUN echo "" > /var/lib/dhcp/dhcpd.leases

ADD ap.sh /opt/ap/ap.sh
ADD get_id.sh /opt/ap/get_id.sh
ADD masquerade.sh /opt/ap/masquerade.sh
ADD clean_firewall.sh /opt/ap/clean_firewall.sh
ADD privoxy.sh /opt/ap/privoxy.sh
ADD tor.sh /opt/ap/tor.sh
ADD _tor.sh /opt/ap/_tor.sh
ADD direct.sh /opt/ap/direct.sh
ADD supervisord.conf /supervisord.conf


ENTRYPOINT ["/usr/bin/supervisord", "-c", "/supervisord.conf"]

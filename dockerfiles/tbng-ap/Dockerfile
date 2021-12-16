FROM debian:stable-slim

RUN apt-get update && apt-get install -y supervisor bash rfkill hostapd iptables isc-dhcp-server iproute2 iw ca-certificates && \
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
ADD supervisord.conf /supervisord.conf

RUN ln -s /opt/ap/masquerade.sh /opt/ap/direct.sh

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/supervisord.conf"]

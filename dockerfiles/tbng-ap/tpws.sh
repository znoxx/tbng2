#!/bin/sh
. /opt/ap/get_id.sh
/opt/ap/clean_firewall.sh
/opt/ap/masquerade.sh
iptables -t nat -A PREROUTING -i ${LAN} -p tcp --dport 80 -j REDIRECT --to-port 8119 -m comment --comment ${FWID}
iptables -t nat -A PREROUTING -i ${LAN} -p tcp --dport 443 -j REDIRECT --to-port 8119 -m comment --comment ${FWID}
iptables -I FORWARD -i ${LAN} -p udp --dport 443 -j DROP -m comment  --comment ${FWID}
echo "Running in TPWS mode"


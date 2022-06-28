#!/bin/sh
. /opt/ap/get_id.sh
/opt/ap/clean_firewall.sh
/opt/ap/masquerade.sh
iptables -t nat -A PREROUTING -i ${LAN} -p tcp --dport 80 -j REDIRECT --to-port 8118 -m comment --comment ${FWID}
/opt/ap/_tor.sh
echo "Running in PRIVOXY mode"


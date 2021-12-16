#!/bin/sh
. /opt/ap/get_id.sh
iptables -t nat -I PREROUTING -i ${LAN} -p udp --dport 53 -j REDIRECT --to-ports 9053 -m comment --comment ${FWID} 
iptables -t nat -A PREROUTING -i ${LAN} -p tcp --syn -j REDIRECT --to-ports 9040 -m comment --comment ${FWID}


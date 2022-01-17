#!/bin/sh
set -e
. /opt/ap/get_id.sh

for tcp_port in $ALLOWED_PORTS_TCP
do
  iptables -t nat -A PREROUTING -i ${LAN} -p tcp --dport $tcp_port -j REDIRECT --to-ports $tcp_port -m comment --comment ${FWID}
done

for udp_port in $ALLOWED_PORTS_UDP
do
  iptables -t nat -A PREROUTING -i ${LAN} -p udp --dport $udp_port -j REDIRECT --to-ports $udp_port -m comment --comment ${FWID}
done

iptables -t nat -I PREROUTING -i ${LAN} -p udp --dport 53 -j REDIRECT --to-ports 9053 -m comment --comment ${FWID} 
iptables -t nat -A PREROUTING -i ${LAN} -p tcp --syn -j REDIRECT --to-ports 9040 -m comment --comment ${FWID}



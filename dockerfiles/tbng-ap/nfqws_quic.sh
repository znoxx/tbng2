#!/bin/sh
. /opt/ap/get_id.sh
/opt/ap/clean_firewall.sh
/opt/ap/masquerade.sh
/opt/ap/_nfqws.sh
iptables -t mangle -A POSTROUTING -o ${WAN} -p udp -m multiport --dports 443 -m connbytes --connbytes 1:6 --connbytes-mode packets --connbytes-dir original -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num 210 --queue-bypass -m comment --comment ${FWID}
echo "Running in NFQWS_QUIC mode"


#!/bin/sh
. /opt/ap/get_id.sh
iptables -t mangle -A INPUT -i ${WAN} -p tcp -m multiport --sports 80,443 -m connbytes --connbytes 1:1 --connbytes-mode packets --connbytes-dir reply  -j NFQUEUE --queue-num 200 --queue-bypass -m comment --comment ${FWID}
iptables -t mangle -A FORWARD -i ${WAN} -p tcp -m multiport --sports 80,443 -m connbytes --connbytes 1:1 --connbytes-mode packets --connbytes-dir reply -j NFQUEUE --queue-num 200 --queue-bypass -m comment --comment ${FWID}
iptables -t mangle -A POSTROUTING -o ${WAN} -p tcp -m multiport --dports 80,443 -m connbytes --connbytes 1:6 --connbytes-mode packets --connbytes-dir original -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num 200 --queue-bypass -m comment --comment ${FWID}
echo "Running in NFQWS mode"


#!/bin/bash
. /opt/ap/get_id.sh
iptables --table nat --append POSTROUTING --out-interface ${WAN} -j MASQUERADE -m comment --comment ${FWID}
iptables --append FORWARD --in-interface ${LAN} -j ACCEPT -m comment --comment ${FWID}
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT -m comment --comment ${FWID}
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT -m comment --comment ${FWID}
echo "NAT settings ip_dynaddr, ip_forward"

for i in ip_dynaddr ip_forward ; do 
  if [ $(cat /proc/sys/net/ipv4/$i) ]; then
    echo $i already 1 
  else
    echo "1" > /proc/sys/net/ipv4/$i
  fi
done

cat /proc/sys/net/ipv4/ip_dynaddr 
cat /proc/sys/net/ipv4/ip_forward


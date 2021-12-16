#!/bin/bash
docker run -i -t --rm -e LAN=wlan0 -e WAN=eth0 -e DNS_SERVERS=192.168.1.24  --net host --cap-add=NET_ADMIN --cap-add=SYS_ADMIN --device /dev/rfkill tbng-ap


#!/bin/bash
. /opt/ap/get_id.sh
iptables-save |grep $FWID|sed -r 's/-A/iptables -D/e'
iptables-save |grep $FWID|sed -r 's/-A/iptables -t nat -D/e'
iptables-save |grep $FWID|sed -r 's/-A/iptables -t mangle -D/e'

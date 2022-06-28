#!/bin/sh
. /opt/ap/get_id.sh
/opt/ap/clean_firewall.sh
/opt/ap/masquerade.sh
echo "Running in DIRECT mode"


#!/bin/sh
echo "Bridge template..."
docker exec bridge_tbng-bridge_1 cat /var/lib/tor/.tor/pt_state/obfs4_bridgeline.txt
echo "Bridge fingerprint..."
docker exec bridge_tbng-bridge_1 cat /var/lib/tor/.tor/fingerprint

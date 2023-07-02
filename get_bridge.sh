#!/bin/sh
echo "Bridge template..."
docker exec tbng-bridge cat /var/lib/tor/.tor/pt_state/obfs4_bridgeline.txt
echo "Bridge fingerprint..."
docker exec tbng-bridge cat /var/lib/tor/.tor/fingerprint

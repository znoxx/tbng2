#!/bin/sh
set -eu
echo $AUTH
CONFIGFILE=/conf/3proxy.noauth
if [ "$AUTH" = 'OPEN' ]; then
  echo "Starting in open mode. Hope you know, what R U doing..."
  CONFIGFILE=/conf/3proxy.noauth
fi

if [ "$AUTH" = 'AUTH' ]; then
  echo "Starting in auth mode. Goog choice!"
  echo $PROXY_USERNAME:`/bin/mycrypt $$ $PROXY_PASSWORD` >> /conf/passwd
  CONFIGFILE=/conf/3proxy.auth
fi

/bin/3proxy $CONFIGFILE

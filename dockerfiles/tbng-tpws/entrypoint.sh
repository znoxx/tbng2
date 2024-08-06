#!/bin/bash -e
# Default values
true ${INTERFACE:=wlan0}
true ${DEBUG_LEVEL:=0}
true ${PORT:=8119}
true ${SETTINGS:='--disorder --tlsrec=sni --split-pos=2'}

if [ -n "${HOST_LIST+set}" ]; then
   echo "Running for hosts in /hostlist.txt: $HOST_LIST"
   echo $HOST_LIST >/hostlist.txt
   COMMAND="/usr/local/bin/tpws --port ${PORT} --bind-iface4=${INTERFACE} --debug=${DEBUG_LEVEL} ${SETTINGS} --hostlist /hostlist.txt"
else
    echo "Running for all hosts..."
   COMMAND="/usr/local/bin/tpws --port ${PORT} --bind-iface4=${INTERFACE} --debug=${DEBUG_LEVEL} ${SETTINGS}"
fi

echo $COMMAND |bash


#!/bin/bash -e
# Default values
true ${INTERFACE:=wlan0}
true ${DEBUG_LEVEL:=0}
true ${PORT:=8119}
true ${SOCKS_PORT:=8120}
true ${SETTINGS:='--disorder --tlsrec=sni --split-pos=2'}

echo "nonexistent.domain" >/hostlist.txt
if [ -n "${HOST_LIST+set}" ]; then
   echo "Running for hosts in /hostlist.txt: $HOST_LIST"
   echo $HOST_LIST |tr " " "\n">>/hostlist.txt
else
    echo "No hostlist provided, using stub"
fi

/usr/local/bin/tpws --port ${PORT} --bind-iface4=${INTERFACE} --debug=${DEBUG_LEVEL} ${SETTINGS} --hostlist /hostlist.txt &
/usr/local/bin/tpws --port ${SOCKS_PORT} --socks  --debug=${DEBUG_LEVEL} ${SETTINGS} --hostlist /hostlist.txt &

wait -n

exit $?


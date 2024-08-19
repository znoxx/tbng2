#!/bin/bash -e
# Default values
true ${SETTINGS:='--dpi-desync=fake,split2 --dpi-desync-ttl=4 --dpi-desync-ttl6=2 --dpi-desync-split-pos=1 --wssize 1:6 --dpi-desync-fooling=md5sig'}
true ${SETTINGS_QUIC:='--dpi-desync=fake,disorder2 --dpi-desync-repeats=6 --dpi-desync-any-protocol --dpi-desync-cutoff=d4'}

echo "nonexistent.domain" >/hostlist.txt


if [ -n "${HOST_LIST+set}" ]; then
   echo "Running for hosts in /hostlist.txt: $HOST_LIST"
   echo $HOST_LIST |tr " " "\n">>/hostlist.txt
else
    echo "No hostlist provided, using stub"
fi

if [ -n "${EXCLUDE_LIST+set}" ]; then
   echo "Running for hosts in /excluded.txt: $EXCLUDE_LIST"
   echo $EXCLUDE_LIST |tr " " "\n">>/exclude.txt
else
    echo "Excluding local addresses by default"
    EXCLUDE_LIST="10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 169.254.0.0/16 fc00::/7 fe80::/10"
fi

echo $EXCLUDE_LIST |tr " " "\n">>/excluded.txt

echo "Starting non-quic nfqws instance..."
/usr/local/bin/nfqws --dpi-desync-fwmark=0x40000000 --qnum=200 ${SETTINGS} --hostlist=/hostlist.txt --hostlist-exclude=/excluded.txt &

if [ -n "${ENABLE_QUIC+set}" ]; then
   echo "Starting quic nfqws instance"
   /usr/local/bin/nfqws --dpi-desync-fwmark=0x40000000 --qnum=210 --dpi-desync-fwmark=0x40000000 ${SETTINGS_QUIC} --hostlist=/hostlist.txt --hostlist-exclude=/excluded.txt &
fi

wait -n
exit $?


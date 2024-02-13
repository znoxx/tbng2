#!/bin/bash -e

# Check if running in privileged mode
#if [ ! -w "/sys" ] ; then
#    echo "[Error] Not running in privileged mode."
#    exit 1
#fi

/opt/ap/clean_firewall.sh

function stop_ap() {
  kill -INT $access_point
  kill -INT `cat /var/run/dhcpd.pid`
  echo "Flushing ${LAN}"
  ip addr flush dev ${LAN}
  /opt/ap/clean_firewall.sh
  echo "Exiting!"
}

trap 'stop_ap' INT

# Default values
true ${WAN:=eth0}
true ${LAN:=wlan0}
true ${SUBNET:=192.168.254.0}
true ${AP_ADDR:=192.168.254.1}
true ${SSID:=docker-ap}
true ${CHANNEL:=11}
true ${COUNTRY_CODE:=RU}
true ${WPA_PASSPHRASE:=passw0rd}
true ${HW_MODE:=g}
true ${DNS_SERVERS:=8.8.8.8, 8.8.4.4}
true ${TOR_MODE:=direct}

if [ "${WAN}" ] ; then
  /opt/ap/${TOR_MODE}.sh

  cat > "/etc/hostapd.conf" <<EOF
interface=${LAN}
driver=nl80211
ssid=${SSID}
hw_mode=${HW_MODE}
channel=${CHANNEL}
country_code=${COUNTRY_CODE}
wpa=2
wpa_passphrase=${WPA_PASSPHRASE}
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
wpa_ptk_rekey=600
ieee80211n=1
wmm_enabled=1 
ignore_broadcast_ssid=0
auth_algs=1
macaddr_acl=0
EOF

  echo "Setting interface ${LAN}"

  # Setup interface and restart DHCP service 
  ip link set ${LAN} up
  ip addr flush dev ${LAN}
  ip addr add ${AP_ADDR}/24 dev ${LAN}


  echo "Configuring DHCP server .."

  cat > "/etc/dhcp/dhcpd.conf" <<EOF
option domain-name-servers ${DNS_SERVERS};
option subnet-mask 255.255.255.0;
option routers ${AP_ADDR};
subnet ${SUBNET} netmask 255.255.255.0 {
  range ${SUBNET::-1}100 ${SUBNET::-1}200;
}
EOF

  echo "Starting DHCP server .."
  kill $(cat /var/run/dhcpd.pid) ||true
  dhcpd ${LAN}

  echo "Starting HostAP daemon ..."
  /usr/sbin/hostapd /etc/hostapd.conf &
  access_point=$!
  wait "$access_point"

else
echo "[Error] WAN (outgoing) interface is not set, exiting!"
fi

# TOR Box Next Generation 2
Almost OOB solution to create:
* TOR/I2P Wifi Access Point
* TOR/I2P Proxy On LAN
* Private TOR Bridge server

This is a successor of [TBNG](https://github.com/znoxx/tbng) project.

## Feature comparison with original TBNG project

TODO

## How it works

TODO

## Requirements

* Any SBC with at least 2 cores CPU and 512MB of RAM, Linux and Docker (and docker-compose). [Armbian](https://armbian.com) is a best bet here.
* Can run on smaller SBC without I2P functionality.
* For private bridge functionality one will need rented VPS (tested with single core, 256Mb cheap KVM box).
* For access point functionality one will need dedicated WAN interface, compatible with nl80211 driver.
* User should be familiar with Docker and docker-compose practices.

## Host system preparation

### SBC preparation

* Make sure you can access Internet from SBC.
* Install docker (better to use latest version from docker.com).
* Install docker-compose. Can be installed via pip tool, install python3-cryptography from OS packages to avoid Rust compiler requirement.

```
# apt-get update
# apt-get install git curl python3-setuptools python3-pip python3-wheel python3-cryptography libffi-dev python3-dev gcc make
# curl https://get.docker.com |sh
# pip3 install docker-compose
```
One can skip python-related packages, gcc and make install, if docker-compose installed not via pip, but via pre-build binary from [official source](https://github.com/docker/compose)

* For AP support -- identify network interface to use for AP (LAN) and internet acess (WAN). 

### Building docker images

Clone the project, if not done before:
```
git clone https://github.com/znoxx/tbng2
cd tbng2
```
Source code is located in `dockerfiles` folder:

```
tbng-3proxy
tbng-ap
tbng-i2p
tbng-privoxy
tbng-tor
```
On SBC one should build following images (i2p may be skipped if no plans to use it):
```
tbng-ap
tbng-i2p
tbng-privoxy
tbng-tor
```
Note about I2P -- one can edit build.sh and change initial I2P version, if more recent version available on [official I2P site](https://geti2p.net/).
But, be careful here -- installation script sequence may be changed, and "expect" magic may fail -- installer script must be updated then.

On dedicated server for private bridge one will need to build following images:
```
tbng-3proxy
tbng-tor
```

Build is relatively simple, just run supplied `build.sh` in appropriate folder:

```
cd dockerfiles/tbng-tor
./build.sh
```

### Configuring SBC
SBC-part is configured by editing config files and docker-compose files

#### conf/tbng-privoxy

Generally, this configuration should not be edited. Privoxy is used to route http(s) requests to TOR. Also it forwards .onion and .i2p domains to tor and i2p respectively.

One can refer to official privoxy [documentation](https://www.privoxy.org/) and add more settings, like filtering. Mind configuration file locations and volumes created.

#### conf/tbng-tor

Mandatory action here -- copy torrc-template to torrc.

If TOR is blocked in your country, you should add some OBFS4 bridges [here](https://bridges.torproject.org/). Template torrc already contains commented example. Just uncomment and insert bridges here.

Or, refer to section about running private TOR bridge on VPS below. You will get own unpublished bridge.

#### compose/tbng2

Further settings are configured in docker-compose.yaml. 


##### I2P part

If usage of I2P is planned -- change i2p snark (torrent client) volume location. In supplied configuration it points to /var/downloads. So, create this folder either point to other location.

If usage of I2P is not planned -- completely remove or comment:

* tbng-i2p service definition
* i2pconf and i2psnark volume definitions

##### Access point part

If no AP functionality is needed -- just comment tbng-ap service completely. 

If AP is used, tweak following settings in "devices" and "environment"

###### Devices: /dev/rfkill passthrogh

Device "rfkill" reference. Can be removed, if no /dev/rfkill in system (for whatever reason)

###### Environment: out and in interfaces

LAN interface should be your AP wifi adapter determined earlier.

WAN interface is your interface for Internet access. You can switch to cable (eth0) or wirelese (in case you have secondary wifi interface).

###### Environment: initial dns

Space separated list of DNS servers to use. Sometimes providers block any DNS servers, except their own. So put here your provider's DNS or homelan one. 

For sure, 8.8.8.8 is possible, if it works for you.

###### Environment: subnet for AP

Subnet and access point IP  -- 192.168.242.0 and 192.168.242.1 in example.

###### Environment: hostapd-related

SSID, channel, password, etc for your access point. Currently configured for 2.4 Ghz AP. One can play with HW_MODE and HT_CAPAB to configure e.g 5 Ghz access. Refer to official hostapd [documentation](https://w1.fi/hostapd/).


###### Environment: Allowed ports 

Ports to open on firewall. By default -- privoxy, tor socks, web access for I2P (TCP), and TOR dns (UDP)

###### Environment: TOR_MODE

Most important setting:

* privoxy -- all traffic is routed via privoxy -- automatic support of .onion and .i2p domains
* tor -- Tor access point. One should explicitly setup http proxy in client systems to allow .onion and .i2p domain operation
* direct -- Just a simple access point. No automatic TOR usage. One can still explicitly setup http proxy in client systems to allow .onion and .i2p domain operation _and_ tor access.

### Running SBC part

Get familiar with enclosed scripts:

* prepare_volumes.sh
* clean_volumes.sh
* start_ap.sh
* stop_ap.sh

General sequence to start from scratch:

Under root:
```
./clean_volumes.sh
./prepare_volumes.sh
```

Under regular user:

```
./start_ap.sh
```

To stop:
```
./stop_ap.sh
```

#### Troubleshooting

Main tor container is healthchecked. So if one receives error like:
```
ERROR: for tbng-ap  Container "some_container_id" is unhealthy.
ERROR: Encountered errors while bringing up the project.

```

Actions here:

* Take a look into container logs
* Make sure it bootstrapped 100%

Most probably there are two reasons to fail:

* torrc settings are not OK
* TOR is blocked in your country

First reason is pretty obvious -- just fix erroneous config.

Second reason is not that straightforward. One will probably need to get some working bridges or make own private bridge. See instructions below.

#### Usage

If I2P is active -- go to http://your_lan_ip_of_tbng2_box:7657 and finalize the setup process via I2P web UI.

After feel free to connect to AP and try to access https://check.torproject.org to check TOR access is OK.

Also one can setup http proxy for other devices on home lan, where needed -- set it to http://your_lan_ip_of_tbng2_box:8118 or socks one -- point to your_lan_ip_of_tbng2_box:9050

#### Restarts and cleaning

System is designed to save persistent data. To start from scratch -- stop via `stop_ap.sh` and then run `clean_volumes.sh`.


## VPS preparation
TODO

### Configuring private bridge (on VPS)
TODO

### Running private bridge
TODO

### Connecting to private bridge from SBC 
TODO

### Using private socks/http(s) proxy at VPS side
TODO

## Results

YMMV here. Generally, using private bridge for TOR gives good results. Here is a result of SpeedTest for a "nice day in TOR".

![result](result.jpg)

Also using USB WiFi Dongle instead of cable connection may introduce some speed degradation.

My own setup runs in LXC container on Orange Pi 4 with wlan0 interface bypassed and /dev/rfkill also for quite long time (yeah, docker inside LXC, because we can).

Also SBC part is tested on cheap and not-so-popular Rock Pi S with 512Mb of RAM.


## Reporting bugs

Before reporting any issues -- check logs for all related containers.

Bug report should contain:

* Expected behaviour
* Actual behaviour

[PasteBin](https://pastebin.com) links for:

* current docker-compose.yaml from compose/tbng2
* torrc from conf/tbng-tor for SBC part
* start_ap.sh result
* docker logs for access point, tor, privoxy, i2p for SBC part
* docker logs for tor and 3proxy for Bridge/VPS part

IMPORTANT: Mind sensitive data like bridge hashes in logs.


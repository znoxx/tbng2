# TOR Box Next Generation 2
Almost OOB solution to create:
* TOR/I2P Wi-Fi Access Point
* TOR/I2P Proxy On LAN (e.g. home LAN)
* Private TOR Bridge server

This is a successor of [TBNG](https://github.com/znoxx/tbng) project.

## Feature comparison with original TBNG project

### WhatZ new

* Linux agnostic. Docker is used, so should work on any SBC/distro, where docker is working.
* No hacks, no non-standard binaries (like hostapd or bigint library for I2P)
* No fuzzy configs, custom scripts

### WhatZ gone

* UI. Probably forever. No reason to overcomplicate system with a UI. docker-compose files are easy to understand and edit.
* MAC spoofing to connect to internet. It's counter-productive to support weird USB Wi-Fi adapters and one can spoof mac address with means of Linux. Read the docs.
* TOR bridge settings via UI. Again, not needed. Also, obfs3 is obsolete and insecure -- obfs4 is good option.


## How it works

SBC part is a set of properly orchestrated containers. 

Containers running in *host* network to allow flawless firewall operation. 

* TOR container, well it's just TOR instance. Can be also used as DNS resolver via port 9053.
* Privoxy is responsible for http proxy functionally, also it forwards .i2p and .onion requests to appropriate container.
* I2P is i2p instance. Since container stores data externally via volume -- it can be updated with I2P internal means.
* Access Point contains all needed components to run hostapd, dhcp server and play with firewall rules. This container requires extra privileges like SYS_ADMIN and NET_ADMIN.

One can change settings via docker-compose and apply new configuration from command line.

VPS part is intended to provide private bridge functionality.

Idea is pretty much the same:

* TOR container works like bridge.
* 3Proxy container provides http/socks proxy functionality with authentication.

## Requirements

* Any SBC with at least 2 cores CPU and 512MB of RAM, Linux and Docker (and docker-compose). [Armbian](https://armbian.com) is the best bet here.
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
Do not forget to add yourself to "docker" group and re-login to use docker without root credentials.

One can skip python-related packages, gcc and make install, if docker-compose installed not via pip, but via pre-build binary from [official source](https://github.com/docker/compose)

* For AP support -- identify network interface to use for AP (LAN) and internet access (WAN). 

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

Generally, this configuration should not be edited. Privoxy is used to route http(s) requests to TOR. Also, it forwards .onion and .i2p domains to tor and i2p respectively.

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

###### Devices: /dev/rfkill passthrough

Device "rfkill" reference. Can be removed, if no /dev/rfkill in system (for whatever reason)

###### Environment: out and in interfaces

LAN interface should be your AP Wi-Fi adapter determined earlier.

WAN interface is your interface for Internet access. You can switch to cable (eth0) or wireless (in case you have secondary Wi-Fi interface).

###### Environment: initial dns

Space separated list of DNS servers to use. Sometimes providers block any DNS servers, except their own. So put here your provider's DNS or home LAN one. 

For sure, 8.8.8.8 is possible, if it works for you.

###### Environment: subnet for AP

Subnet and access point IP  -- 192.168.242.0 and 192.168.242.1 in example.

###### Environment: hostapd-related

SSID, channel, password, etc. for your access point. By default, it is configured for 2.4 Ghz AP. One can play with HW_MODE and HT_CAPAB to configure e.g 5 Ghz access. Refer to official hostapd [documentation](https://w1.fi/hostapd/).


###### Environment: Allowed ports 

Ports to open on firewall. By default -- privoxy, tor socks, ssh, web access for I2P (TCP), and TOR dns (UDP)

###### Environment: TOR_MODE

Most important setting:

* privoxy -- all traffic is routed via privoxy -- automatic support of .onion and .i2p domains
* tor -- Tor access point. One should explicitly set up http proxy in client systems to allow .onion and .i2p domain operation
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

Main tor container is health checked. So if one receives error like:
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

Also, one can set up http proxy for other devices on home lan, where needed -- set it to http://your_lan_ip_of_tbng2_box:8118 or socks one -- point to your_lan_ip_of_tbng2_box:9050

#### Restarts and cleaning

System is designed to save persistent data. To start from scratch -- stop via `stop_ap.sh` and then run `clean_volumes.sh`.


## VPS preparation
VPS is used to work as your "personal bridge". Also, it is possible to use same VPS as socks and http proxy with authentication (since it is running in "open Internet").
VPS can be rented in country, where TOR is not blocked. But in my case it runs even after blocking was announced. Only difference -- TOR bootstraps quite significant time.

VPS requirements are quite humble -- even 256Mb (with swap enabled) system with 1 CPU core will do. For best results 512Mb box should be rented.

On fresh VPS install docker and docker-compose -- just follow same steps described in SBC part above.

### Configuring private bridge (on VPS)
After cloning the project -- build required docker images:

* tbng-3proxy
* tbng-tor

3proxy image will provide external http/socks proxy functionality. This part is optional one, so feel free to comment it in `compose/bridge/docker-compose.yaml`.

But if one wants external proxy -- one extra step is required -- creating `.env` file in project root. It will contain 3 parameters:

```
AUTH=AUTH
PROXY_USERNAME=desired-proxy-username
PROXY_PASSWORD=desired-proxy-password
```

First parameters tells system to run with authentication. Other two are credentials.

By default, proxy will run on 10800 (socks) and 8888 (http). This can be changed in `compose/bridge/docker-compose.yaml`.

`conf/tbng-bridge/torrc` is already preconfigured, only one thing to change here is a Nickname

### Running private bridge
To start a bridge -- execute command in project root dir:
```
./start_bridge.sh
```

If no blocks encountered system will start in some reasonable time. One can check status with "docker logs container_name". 

When system is up, one will need to grab credentials for running bridge:
```
./get_bridge.sh 
Bridge template...
# obfs4 torrc client bridge line
#
# This file is an automatically generated bridge line based on
# the current obfs4proxy configuration.  EDITING IT WILL HAVE
# NO EFFECT.
#
# Before distributing this Bridge, edit the placeholder fields
# to contain the actual values:
#  <IP ADDRESS>  - The public IP address of your obfs4 bridge.
#  <PORT>        - The TCP/IP port of your obfs4 bridge.
#  <FINGERPRINT> - The bridge's fingerprint.

Bridge obfs4 <IP ADDRESS>:<PORT> <FINGERPRINT> cert=BlahBlahYadaYadaYadaFooBar iat-mode=0
Bridge fingerprint...
zaloopa BLAHBLAHF00BARYADAYADA

```

Now construct new bridge line from provided data. It will be like this:
```
bridge obfs4 your.vps.ip.addr:4443 BLAHBLAHF00BARYADAYADA cert=BlahBlahYadaYadaYadaFooBar iat-mode=0
```

Save it to some handy place and proceed to your SBC installation (or even TorBrowser or any other TOR instance).

This config persistent. To flush it -- cleanup volumes with enclosed script. New credentials will be generated on next start. Don't forget to change it on clients.

### Connecting to private bridge from SBC 
In torrc add the following section. It already exists in torrc-template, but commented. So your final config will be like this:

```
######Bridges
UseBridges 1
ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy managed
### get your own bridge!
bridge obfs4 your.vps.ip.addr:4443 BLAHBLAHF00BARYADAYADA cert=BlahBlahYadaYadaYadaFooBar iat-mode=0
######Bridges end
```
Restart your tor instance and see it working.

### Using private socks/http(s) proxy at VPS side
Just use address your.vps.ip.addr:8888 as http proxy or your.vps.ip.addr:9050 as socks one. Keep credentials safe, use some complicated password.

## Results

YMMV here. Generally, using private bridge for TOR gives good results. Here is a result of SpeedTest for a "nice day in TOR".

![result](result.jpg)

Also using USB Wi-Fi Dongle instead of cable connection may introduce some speed degradation.

My own setup runs in LXC container on Orange Pi 4 with wlan0 interface bypassed and /dev/rfkill also for quite long time (yeah, docker inside LXC, because we can).

Also, SBC part is tested on cheap and not-so-popular Rock Pi S with 512Mb of RAM.

## Test matrix

Simple test matrix used to check functionality:

| MODE    | Inet access | SSH access via AP | External proxy (8118) |
| ------- | ----------- | ----------------- | --------------------- |
| direct  | ok/ko       | ok/ko             | ok/ko                 |
| tor     | ok/ko       | ok/ko             | ok/ko                 |
| privoxy | ok/ko       | ok/ko             | ok/ko                 |


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


## Roadmap

Actually, system does, what it does. There is a couple of things to solve someday.

* Docker image multistage build -- all images use same debian build. Good to have common packages pre-installed in one "common image" to avoid re-downloading and re-installing.
* I2P installer improvements. I2P installation is done in "hacky" way using expect. This may f*ck up after I2P version update. Need to find out more reliable way to avoid service misbehave.

However, pull requests are welcome!





.PHONY: clean

3PROXY_RELEASE := 0.9.4
I2P_VERSION := 2.6.0

all:
	echo "Select bridge or access_point"
	false
common:
	docker build dockerfiles/tbng-common -t tbng-common
tor: common
	docker build dockerfiles/tbng-tor -t tbng-tor
i2p: common
	docker build dockerfiles/tbng-i2p --build-arg I2P_VERSION=$(I2P_VERSION) -t tbng-i2p
3proxy: common
	docker build dockerfiles/tbng-3proxy -t tbng-3proxy_ds --build-arg RELEASE=$(3PROXY_RELEASE) --build-arg ARCH=`uname -m`
ap: common
	docker build dockerfiles/tbng-ap -t tbng-ap
privoxy: common
	docker build dockerfiles/tbng-privoxy -t tbng-privoxy
tpws: common
	docker build dockerfiles/tbng-tpws -t tbng-tpws --build-arg ARCH=`uname -m`


bridge: tor 3proxy
access_point: tor ap privoxy tpws

clean:
	docker image rm tbng-3proxy_ds tbng-tor tbng-i2p tbng-ap tbng-privoxy tbng-common tbng-tpws


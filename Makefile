.PHONY: clean

3PROXY_RELEASE := 0.9.4
I2P_VERSION := 1.8.0

all:
	echo "Select bridge or access_point"
	false
tor:
	docker build dockerfiles/tbng-tor -t tbng-tor
i2p:
	docker build dockerfiles/tbng-i2p --build-arg I2P_VERSION=$(I2P_VERSION) -t tbng-i2p
3proxy:
	docker build dockerfiles/tbng-3proxy -t tbng-3proxy_ds --build-arg RELEASE=$(3PROXY_RELEASE) --build-arg ARCH=`uname -m`
ap:
	docker build dockerfiles/tbng-ap -t tbng-ap
privoxy:
	docker build dockerfiles/tbng-privoxy -t tbng-privoxy


bridge: tor 3proxy
access_point: tor ap privoxy

clean:
	docker image rm tbng-3proxy_ds tbng-tor tbng-i2p tbng-ap tbng-privoxy

